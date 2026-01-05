// ignore_for_file: deprecated_member_use

import 'package:control/control.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:ignitor/src/features/quotes/controller/quotes_controller.dart';
import 'package:ui/ui.dart';

class Quotes$Layout$Successful extends StatefulWidget {
  const Quotes$Layout$Successful({required this.quotes, super.key});
  final Entities<QuoteEntity> quotes;

  @override
  State<Quotes$Layout$Successful> createState() =>
      _Quotes$Layout$SuccessfulState();
}

class _Quotes$Layout$SuccessfulState extends State<Quotes$Layout$Successful>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotes = widget.quotes;
    return PullToRefresh.child(
      onRefresh: context.controllerOf<QuotesController>().fetchQuotes,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        physics: const BouncingScrollPhysics(),
        itemCount: quotes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final quote = quotes[index];
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index / quotes.length).clamp(0.0, 0.95),
              1,
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .05),
                end: Offset.zero,
              ).animate(animation),
              child: _QuoteCard(quote: quote),
            ),
          );
        },
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});
  final QuoteEntity quote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121317) : const Color(0xFFF7F7FB),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: -6,
            offset: const Offset(0, 14),
            color:
                isDark
                    ? Colors.black.withOpacity(.35)
                    : Colors.black.withOpacity(.08),
          ),
        ],
        border: Border.all(
          color:
              isDark
                  ? const Color.fromARGB(255, 30, 32, 39)
                  : const Color(0xFFE7E8EE),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: author pill
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? const Color(0xFF1E2027)
                          : const Color(0xFFEFF1FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  quote.author.isEmpty ? 'Unknown' : quote.author,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: .2,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.format_quote, size: 20, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          // Body: quote text
          Text(
            quote.text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          // Footer: subtle divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  // ignore: prefer_if_elements_to_conditional_expressions
                  (isDark ? Colors.white12 : Colors.black12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 16,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(
                'Quote',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
