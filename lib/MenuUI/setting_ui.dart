import 'package:flutter/material.dart';

import 'login_page_ui.dart';
import 'theme_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            ),
            child: const Text('Yes, Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDualColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Mixer'),
        content: const SizedBox(
          width: 300,
          height: 350,
          child: DualColorMixer(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ThemeManager.resetToDefault();
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Reset Defaults'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeColors>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, theme, _) {
        final Color contrast = ThemeManager.contrastColor;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, theme.secondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                widget.title,
                style: TextStyle(color: contrast),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: contrast),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSettingCard(
                    Icons.person,
                    'Account Settings',
                    contrast,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    Icons.colorize,
                    'Customization',
                    contrast,
                    subtitle:
                        'Left/right changes color, top is white, bottom is black',
                    onTap: _showDualColorPicker,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    Icons.logout,
                    'Sign Out',
                    Colors.redAccent,
                    onTap: _showSignOutDialog,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: contrast.withValues(alpha: 0.1),
                      foregroundColor: contrast,
                      elevation: 0,
                      side: BorderSide(
                        color: contrast.withValues(alpha: 0.2),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Return'),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingCard(
    IconData icon,
    String title,
    Color textColor, {
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      color: ThemeManager.primaryColor.computeLuminance() > 0.5
          ? Colors.white.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: textColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

class DualColorMixer extends StatefulWidget {
  const DualColorMixer({super.key});

  @override
  State<DualColorMixer> createState() => _DualColorMixerState();
}

class _DualColorMixerState extends State<DualColorMixer> {
  static const double pickerSize = 300;

  late Offset topPos;
  late Offset bottomPos;

  @override
  void initState() {
    super.initState();
    topPos = _getOffsetFromColor(ThemeManager.secondaryColor);
    bottomPos = _getOffsetFromColor(ThemeManager.primaryColor);
  }

  Offset _getOffsetFromColor(Color color) {
    final HSLColor hsl = HSLColor.fromColor(color);

    final double x = (hsl.hue / 360.0) * pickerSize;
    final double y = (1.0 - hsl.lightness) * pickerSize;

    return Offset(
      x.clamp(0.0, pickerSize),
      y.clamp(0.0, pickerSize),
    );
  }

  Color _getColorFromOffset(Offset offset) {
    final double hue = (offset.dx / pickerSize).clamp(0.0, 1.0) * 360.0;
    final double lightness =
        (1.0 - (offset.dy / pickerSize)).clamp(0.0, 1.0);

    return HSLColor.fromAHSL(
      1.0,
      hue,
      1.0,
      lightness,
    ).toColor();
  }

  void _updateColors() {
    ThemeManager.updateColors(
      _getColorFromOffset(bottomPos),
      _getColorFromOffset(topPos),
    );
  }

  void _moveNearestHandle(Offset local) {
    final Offset clamped = Offset(
      local.dx.clamp(0.0, pickerSize),
      local.dy.clamp(0.0, pickerSize),
    );

    setState(() {
      if ((clamped - topPos).distance < (clamped - bottomPos).distance) {
        topPos = clamped;
      } else {
        bottomPos = clamped;
      }

      _updateColors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Left / Right = Color',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        const Text(
          'Top = White     Middle = Color     Bottom = Black',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTapDown: (details) {
            _moveNearestHandle(details.localPosition);
          },
          onPanUpdate: (details) {
            _moveNearestHandle(details.localPosition);
          },
          child: SizedBox(
            width: pickerSize,
            height: pickerSize,
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(pickerSize, pickerSize),
                  painter: ColorSquarePainter(),
                ),
                Positioned(
                  left: topPos.dx - 12,
                  top: topPos.dy - 12,
                  child: _ColorHandle(
                    color: ThemeManager.secondaryColor,
                    label: 'T',
                  ),
                ),
                Positioned(
                  left: bottomPos.dx - 12,
                  top: bottomPos.dy - 12,
                  child: _ColorHandle(
                    color: ThemeManager.primaryColor,
                    label: 'B',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorHandle extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorHandle({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ColorSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Shader hueGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFFF0000),
        Color(0xFFFFFF00),
        Color(0xFF00FF00),
        Color(0xFF00FFFF),
        Color(0xFF0000FF),
        Color(0xFFFF00FF),
        Color(0xFFFF0000),
      ],
    ).createShader(rect);

    final Shader whiteOverlay = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Colors.white.withValues(alpha: 0),
        Colors.white.withValues(alpha: 0),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);

    final Shader blackOverlay = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0),
        Colors.black.withValues(alpha: 0),
        Colors.black,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);

    canvas.drawRect(rect, Paint()..shader = hueGradient);
    canvas.drawRect(rect, Paint()..shader = whiteOverlay);
    canvas.drawRect(rect, Paint()..shader = blackOverlay);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}