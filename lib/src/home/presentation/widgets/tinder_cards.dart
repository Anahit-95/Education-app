import 'package:educational_app/core/extensions/context_extension.dart';
import 'package:educational_app/core/res/media_res.dart';
import 'package:educational_app/src/home/presentation/widgets/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards>
    with TickerProviderStateMixin {
  final CardController cardController = CardController();

  int totalCards = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: context.width,
        width: context.width,
        child: TinderSwapCard(
          totalNum: totalCards,
          cardController: cardController,
          swipeEdge: 4,
          maxWidth: context.width,
          maxHeight: context.width * 0.9,
          minWidth: context.width * .71,
          minHeight: context.width * .85,
          allowSwipe: false,
          swipeUpdateCallback: (_, align) {
            // Get card alignment
            if (align.x < 0) {
              // Card is Left swiping
            } else if (align.x > 0) {
              // Card is Right swiping
            }
          },
          swipeCompleteCallback: (orientation, index) {
            // if the card was the last card, add more cards to be swiped
            if (index == totalCards - 1) {
              setState(() {
                totalCards += 10;
              });
            }
          },
          cardBuilder: (context, index) {
            final isFirst = index == 0;
            final colorByIndex =
                index == 1 ? const Color(0xFFDA92FC) : const Color(0xFFDC95FB);
            return Stack(
              children: [
                Positioned(
                  bottom: 110,
                  right: 0,
                  left: 0,
                  child: TinderCard(
                    isFirst: isFirst,
                    colour: isFirst ? null : colorByIndex,
                  ),
                ),
                if (isFirst)
                  Positioned(
                    bottom: 130,
                    right: 20,
                    child: Image.asset(
                      MediaRes.microscope,
                      height: 180,
                      width: 149,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
