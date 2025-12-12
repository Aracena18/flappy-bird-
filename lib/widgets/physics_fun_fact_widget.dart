import 'package:flutter/material.dart';
import '../models/physics_fact.dart';

class PhysicsFunFactWidget extends StatelessWidget {
  final PhysicsFact fact;
  final Duration displayDuration;
  final VoidCallback? onDismiss;

  const PhysicsFunFactWidget({
    super.key,
    required this.fact,
    this.displayDuration = const Duration(seconds: 5),
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    final isMediumScreen = screenWidth < 600;

    // Responsive sizing
    final containerMargin = isSmallScreen ? 10.0 : (isMediumScreen ? 12.0 : 16.0);
    final containerPadding = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 16.0);
    final iconSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 24.0);
    final titleFontSize = isSmallScreen ? 10.0 : (isMediumScreen ? 11.0 : 12.0);
    final headerFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 15.0 : 16.0);
    final descriptionFontSize = isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 14.0);
    final badgeFontSize = isSmallScreen ? 9.0 : (isMediumScreen ? 10.0 : 11.0);
    final infoFontSize = isSmallScreen ? 12.0 : (isMediumScreen ? 12.5 : 13.0);
    final spacingSmall = isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0);

    return Container(
      margin: EdgeInsets.all(containerMargin),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3498DB),
            const Color(0xFF2980B9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: const Color(0xFFF39C12),
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacingSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Physics Fun Fact',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      fact.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: headerFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                SizedBox(
                  width: isSmallScreen ? 32 : 40,
                  height: isSmallScreen ? 32 : 40,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: onDismiss,
                    padding: EdgeInsets.zero,
                    iconSize: isSmallScreen ? 18 : 20,
                  ),
                ),
            ],
          ),
          SizedBox(height: spacingSmall),

          // Description
          Text(
            fact.description,
            style: TextStyle(
              color: Colors.white,
              fontSize: descriptionFontSize,
              height: 1.5,
            ),
          ),

          // Fun fact highlight if available
          if (fact.funFact != null) ...[
            SizedBox(height: spacingSmall),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF39C12).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFFF39C12),
                    size: isSmallScreen ? 18 : 20,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: Text(
                      fact.funFact!,
                      style: TextStyle(
                        color: const Color(0xFFFFC107),
                        fontSize: infoFontSize,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Category badge
          SizedBox(height: spacingSmall),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 10 : 12,
              vertical: isSmallScreen ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Category: ${fact.category.toUpperCase()}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: badgeFontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

