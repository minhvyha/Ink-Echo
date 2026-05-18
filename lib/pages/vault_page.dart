import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/pages/book_detail_page.dart';
import 'package:inkandecho/pages/reflection_page.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/theme/ink_echo_tokens.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import 'package:inkandecho/utils/vault_book_list.dart';
import 'package:inkandecho/widgets/vault/vault_app_bar.dart';
import 'package:inkandecho/widgets/vault/vault_bento_cards.dart';
import 'package:inkandecho/widgets/vault/vault_drawer.dart';

class VaultPage extends StatefulWidget {
  final VoidCallback onOpenSettings;

  const VaultPage({super.key, required this.onOpenSettings});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  bool _searchActive = false;
  String _searchQuery = '';
  VaultSortOrder _sortOrder = VaultSortOrder.newest;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _openAdd() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReflectionPage(
          onBookSaved: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openDetail(Book book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookDetailPage(book: book),
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
      body: StreamBuilder<List<Book>>(
        stream: BookService.instance.watchBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allBooks = snapshot.data ?? const <Book>[];
          final books = _prepareBooks(allBooks);
          final loading = snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData;
          final searching = _searchQuery.trim().isNotEmpty;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 64)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      InkEchoTokens.gutter,
                      8,
                      InkEchoTokens.gutter,
                      120,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (_searchActive && searching) ...[
                          Text(
                            'Results',
                            style: context.vaultDisplayLg,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${books.length} ${books.length == 1 ? 'entry' : 'entries'} found',
                            style: context.vaultBodyLg,
                          ),
                        ] else ...[
                          Text('Your Vault', style: context.vaultDisplayLg),
                          const SizedBox(height: 4),
                          Text(
                            'A quiet space for scattered thoughts.',
                            style: context.vaultBodyLg,
                          ),
                        ],
                        const SizedBox(height: InkEchoTokens.gap),
                        if (loading)
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
