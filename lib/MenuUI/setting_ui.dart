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
        content: const Text('Are you sure you want to sign out?',
            style: TextStyle(color: Colors.red)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false),
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
          height: 300,
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
              child: const Text('Done')),
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
              title: Text(widget.title, style: TextStyle(color: contrast)),
              centerTitle: true,
              iconTheme: IconThemeData(color: contrast),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSettingCard(Icons.person, 'Account Settings', contrast),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    Icons.colorize,
                    'Customization',
                    contrast,
                    subtitle: 'Left edge for White/Black, Center for Colors',
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
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: contrast.withOpacity(0.1),
                      foregroundColor: contrast,
                      elevation: 0,
                      side: BorderSide(color: contrast.withOpacity(0.2)),
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

  Widget _buildSettingCard(IconData icon, String title, Color textColor,
      {String? subtitle, VoidCallback? onTap}) {
    return Card(
      color: ThemeManager.primaryColor.computeLuminance() > 0.5
          ? Colors.white.withOpacity(0.4)
          : Colors.black.withOpacity(0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: textColor.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: textColor),
        title: Text(title,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.7)))
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
  late Offset topPos;
  late Offset bottomPos;

  @override
  void initState() {
    super.initState();
    topPos = _getOffsetFromColor(ThemeManager.secondaryColor);
    bottomPos = _getOffsetFromColor(ThemeManager.primaryColor);
  }

  Offset _getOffsetFromColor(Color color) {
    HSVColor hsv = HSVColor.fromColor(color);
    // x = Hue, y = Value (inverted)
    // If saturation is low, we assume it's on the left grayscale edge
    double x = hsv.saturation < 0.1 ? 0 : hsv.hue / 360;
    return Offset(x, 1 - hsv.value);
  }

  Color _getColorFromOffset(Offset offset) {
    // If X is 0, Saturation is 0 (Grayscale). Otherwise, Saturation is high for vivid colors.
    double saturation = offset.dx < 0.05 ? 0.0 : 0.85;
    double value = 1.0 - offset.dy;
    return HSVColor.fromAHSV(1.0, offset.dx * 360, saturation, value).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset localPos = box.globalToLocal(details.globalPosition);
            double x = (localPos.dx / constraints.maxWidth).clamp(0.0, 1.0);
            double y = (localPos.dy / constraints.maxHeight).clamp(0.0, 1.0);

            setState(() {
              Offset newPos = Offset(x, y);
              if ((newPos - topPos).distance < (newPos - bottomPos).distance) {
                topPos = newPos;
              } else {
                bottomPos = newPos;
              }
              ThemeManager.updateColors(
                  _getColorFromOffset(bottomPos), _getColorFromOffset(topPos));
            });
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ColorSquarePainter(),
                ),
              ),
              _dot(topPos, constraints, "TOP", _getColorFromOffset(topPos)),
              _dot(bottomPos, constraints, "BTM", _getColorFromOffset(bottomPos)),
            ],
          ),
        );
      },
    );
  }

  Widget _dot(Offset pos, BoxConstraints constraints, String label, Color color) {
    return Positioned(
      left: pos.dx * constraints.maxWidth - 18,
      top: pos.dy * constraints.maxHeight - 18,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2)]))),
      ),
    );
  }
}

class ColorSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Draw the rainbow spectrum
    final hueGradient = LinearGradient(colors: [
      const Color(0xFFFF0000), const Color(0xFFFFFF00),
      const Color(0xFF00FF00), const Color(0xFF00FFFF),
      const Color(0xFF0000FF), const Color(0xFFFF00FF),
      const Color(0xFFFF0000),
    ]).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = hueGradient);

    // 2. Draw a white-to-transparent overlay on the very left to allow "White"
    final whiteOverlay = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.15],
      colors: [Colors.white, Colors.white.withOpacity(0)],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = whiteOverlay);

    // 3. Draw a vertical Value (Brightness) Gradient: Top is transparent, Bottom is Black
    // This allows the user to slide to the bottom for pure black.
    final valueGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.black.withOpacity(0), Colors.black],
    ).createShader(rect);
    
    canvas.drawRect(
      rect, 
      Paint()
        ..shader = valueGradient
        ..blendMode = BlendMode.srcOver
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}