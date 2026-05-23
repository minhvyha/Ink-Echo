// Home vault: live Firestore list, search, sort drawer, bento cards.

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/models/vault_books_state.dart';
import 'package:inkandecho/pages/book_detail_page.dart';
import 'package:inkandecho/pages/reflection_page.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/theme/ink_echo_tokens.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import 'package:inkandecho/utils/vault_book_list.dart';
import 'package:inkandecho/widgets/vault/vault_app_bar.dart';
import 'package:inkandecho/widgets/vault/vault_bento_cards.dart';
import 'package:inkandecho/widgets/vault/vault_drawer.dart';
import 'package:inkandecho/widgets/vault/vault_sync_banner.dart';

/// Main library screen after sign-in ([MainShell] tab 0).
///
/// Streams books via [BookService.watchVault], supports client-side
/// search/sort, offline cache banners, and retry on load errors.
class VaultPage extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final BookService? bookService;

  const VaultPage({
    super.key,
    required this.onOpenSettings,
    this.bookService,
  });

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  late Stream<VaultBooksState> _vaultStream;
  int _vaultGeneration = 0;

  /// App bar toggles between brand row and inline search field.
  bool _searchActive = false;
  String _searchQuery = '';
  /// Persisted only for this session; chosen from [VaultDrawer].
  VaultSortOrder _sortOrder = VaultSortOrder.newest;

  BookService get _bookService => widget.bookService ?? BookService.instance;

  @override
  void initState() {
    super.initState();
    _vaultStream = _bookService.watchVault();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _retryVaultLoad() async {
    await BookService.retryConnection();
    if (!mounted) return;
    setState(() {
      _vaultGeneration++;
      _vaultStream = _bookService.watchVault();
    });
  }

  void _openAdd() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReflectionPage(
          bookService: _bookService,
          onBookSaved: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openDetail(Book book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookDetailPage(
          book: book,
          bookService: _bookService,
        ),
      ),
    );
  }

  void _openMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _startSearch() {
    setState(() => _searchActive = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocus.requestFocus();
    });
  }

  void _closeSearch() {
    _searchController.clear();
    _searchFocus.unfocus();
    setState(() {
      _searchActive = false;
      _searchQuery = '';
    });
  }

  /// Applies drawer sort order, then app-bar search filter.
  List<Book> _prepareBooks(List<Book> books) {
    final sorted = sortVaultBooks(books, _sortOrder);
    return filterVaultBooks(sorted, _searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: VaultDrawer(
        sortOrder: _sortOrder,
        onSortChanged: (order) => setState(() => _sortOrder = order),
        onOpenSettings: widget.onOpenSettings,
        onAddReflection: _openAdd,
      ),
      body: StreamBuilder<VaultBooksState>(
        key: ValueKey(_vaultGeneration),
        stream: _vaultStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.showOfflineEmpty) {
            return _VaultRefreshableScroll(
              onRefresh: _retryVaultLoad,
              child: _VaultOfflineEmpty(
                onRetry: _retryVaultLoad,
                topInset: VaultAppBar.totalHeight(context),
              ),
            );
          }

          if (state.hasError && state.books.isEmpty && !state.isLoading) {
            return _VaultRefreshableScroll(
              onRefresh: _retryVaultLoad,
              child: _VaultLoadError(
                state: state,
                onRetry: _retryVaultLoad,
                topInset: VaultAppBar.totalHeight(context),
              ),
            );
          }

          final books = _prepareBooks(state.books);
          final searching = _searchQuery.trim().isNotEmpty;
          final topBarHeight = VaultAppBar.totalHeight(context);

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _retryVaultLoad,
                child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: topBarHeight)),
                  SliverToBoxAdapter(
                    child: VaultSyncBanner(
                      state: state,
                      onRetry: _retryVaultLoad,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      InkEchoTokens.gutter,
                      20,
                      InkEchoTokens.gutter,
                      120,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (_searchActive && searching) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Results',
                                  style: context.vaultDisplayLg,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${books.length} ${books.length == 1 ? 'entry' : 'entries'} found',
                                  style: context.vaultBodyLg,
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Vault',
                                  style: context.vaultDisplayLg,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'A quiet space for scattered thoughts.',
                                  style: context.vaultBodyLg,
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: InkEchoTokens.gap),
                        if (state.isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 64),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (searching && books.isEmpty)
                          _VaultSearchEmpty(query: _searchQuery.trim())
                        else ...[
                          if (books.isNotEmpty) ...[
                            VaultFeaturedCard(
                              book: books.first,
                              onTap: () => _openDetail(books.first),
                            ),
                            const SizedBox(height: InkEchoTokens.gap),
                            for (var i = 1; i < books.length; i++) ...[
                              VaultEntryCard(
                                book: books[i],
                                onTap: () => _openDetail(books[i]),
                                squareImage: i.isOdd,
                                useSecondaryDate: i.isEven,
                              ),
                              const SizedBox(height: InkEchoTokens.gap),
                            ],
                          ],
                          if (!searching)
                            VaultNewEntryCard(onWrite: _openAdd),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: VaultAppBar(
                  searchActive: _searchActive,
                  searchController: _searchController,
                  searchFocusNode: _searchFocus,
                  onMenuTap: _openMenu,
                  onSearchTap: _startSearch,
                  onSearchClose: _closeSearch,
                  onSearchChanged: (value) =>
                      setState(() => _searchQuery = value),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Pull-to-refresh wrapper for full-screen vault states (empty offline / error).
class _VaultRefreshableScroll extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const _VaultRefreshableScroll({
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _VaultOfflineEmpty extends StatelessWidget {
  final VoidCallback onRetry;
  final double topInset;

  const _VaultOfflineEmpty({
    required this.onRetry,
    required this.topInset,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, topInset + 24, 24, 24),
      child: Column(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 56,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 20),
          Text(
            'You\'re offline',
            style: context.vaultHeadline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Connect to the internet to load your vault, or retry if you '
            'were just offline. Cached entries appear automatically when available.',
            style: context.vaultBodyLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _VaultLoadError extends StatelessWidget {
  final VaultBooksState state;
  final VoidCallback onRetry;
  final double topInset;

  const _VaultLoadError({
    required this.state,
    required this.onRetry,
    required this.topInset,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, topInset + 24, 24, 24),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 56,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 20),
          Text(
            'Could not load your vault',
            style: context.vaultHeadline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            BookService.messageForError(state.error!),
            style: context.vaultBodyLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _VaultSearchEmpty extends StatelessWidget {
  final String query;

  const _VaultSearchEmpty({required this.query});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 48,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No entries match “$query”',
            textAlign: TextAlign.center,
            style: context.vaultHeadline,
          ),
          const SizedBox(height: 8),
          Text(
            'Try another title, author, mood, or phrase from your reflection.',
            textAlign: TextAlign.center,
            style: context.vaultBodyLg,
          ),
        ],
      ),
    );
  }
}
