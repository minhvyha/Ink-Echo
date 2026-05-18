import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/pages/book_detail_page.dart';
import 'package:inkandecho/pages/reflection_page.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/theme/ink_echo_tokens.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import 'package:inkandecho/widgets/vault/vault_app_bar.dart';
import 'package:inkandecho/widgets/vault/vault_bento_cards.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  void _openAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReflectionPage(
          onBookSaved: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, Book book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookDetailPage(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Book>>(
        stream: BookService.instance.watchBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final books = snapshot.data ?? const <Book>[];
          final loading = snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData;

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
                        Text('Your Vault', style: context.vaultDisplayLg),
                        const SizedBox(height: 4),
                        Text(
                          'A quiet space for scattered thoughts.',
                          style: context.vaultBodyLg,
                        ),
                        const SizedBox(height: InkEchoTokens.gap),
                        if (loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 64),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else ...[
                          if (books.isNotEmpty) ...[
                            VaultFeaturedCard(
                              book: books.first,
                              onTap: () => _openDetail(context, books.first),
                            ),
                            const SizedBox(height: InkEchoTokens.gap),
                            for (var i = 1; i < books.length; i++) ...[
                              VaultEntryCard(
                                book: books[i],
                                onTap: () => _openDetail(context, books[i]),
                                squareImage: i.isOdd,
                                useSecondaryDate: i.isEven,
                              ),
                              const SizedBox(height: InkEchoTokens.gap),
                            ],
                          ],
                          VaultNewEntryCard(
                            onWrite: () => _openAdd(context),
                          ),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: VaultAppBar(),
              ),
            ],
          );
        },
      ),
    );
  }
}
