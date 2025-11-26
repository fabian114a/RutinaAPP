import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
AudioPlayer audioPlayer = AudioPlayer();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  bool isRegistered = prefs.getBool('isRegistered') ?? false;

  // Si es el primer inicio o no está registrado, muestra la pantalla de bienvenida
  // Si ya está registrado, redirígelo directamente a la pantalla de RutinaPantalla
  runApp(MyApp(isFirstTime: isFirstTime, isRegistered: isRegistered));
}


class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isRegistered;

  MyApp({required this.isFirstTime, required this.isRegistered});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutina App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Si es el primer inicio, muestra la pantalla de bienvenida, 
      // si no, y está registrado, lleva a RutinaPantalla
      home: isFirstTime
          ? BienvenidaPantalla()
          : (isRegistered ? RutinaPantalla() : RegistroPantalla()),
          routes: {
              "/registro": (context) => RegistroPantalla(),
              "/experiencia": (context) => ExperienciaPantalla(),
              "/meta": (context) => MetaPantalla(),
              "/rutina": (context) => RutinaPantalla(),
              "/progreso": (context) => ProgresoPantalla(),
              
            },
    );
    
  }
}


//PANTALLA DE BIENVENIDA//

class BienvenidaPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),

          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // LOGO
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 180,
                  ),
                ),

                SizedBox(height: 30),

                // TARJETA
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),

                  child: Column(
                    children: [
                      Text(
                        "Bienvenido a Rutina App",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Tu compañero perfecto para mejorar tu condición física. "
                        "Crea rutinas personalizadas según tu nivel, objetivo y progreso.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),

                      SizedBox(height: 35),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            await prefs.setBool('isFirstTime', false);

                            Navigator.pushReplacementNamed(
                                context, "/registro");
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 50, 120, 185),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 40),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                          ),

                          child: Text("Comenzar"),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//PANTALLA DE REGISTRO//

class RegistroPantalla extends StatefulWidget {
  @override
  _RegistroPantallaState createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _estaturaController = TextEditingController();

  Future<void> _registrar() async {
    if (_nombreController.text.isNotEmpty &&
        _edadController.text.isNotEmpty &&
        _pesoController.text.isNotEmpty &&
        _estaturaController.text.isNotEmpty) {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', _nombreController.text);
      await prefs.setString('edad', _edadController.text);
      await prefs.setString('peso', _pesoController.text);
      await prefs.setString('estatura', _estaturaController.text);

      Navigator.pushReplacementNamed(context, "/experiencia");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor completa todos los campos"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _campo(String label, IconData icon, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 40, 40, 40),
            )),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color.fromARGB(255, 50, 120, 185)),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 5, 103, 184), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            children: [
              
              // LOGO
              AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 1800),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 140,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Registro de Usuario",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 103, 184),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // TARJETA
              Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _campo("Nombre", Icons.person, _nombreController),
                    SizedBox(height: 18),
                    _campo("Edad", Icons.cake, _edadController,
                        type: TextInputType.number),
                    SizedBox(height: 18),
                    _campo("Peso (kg)", Icons.monitor_weight, _pesoController,
                        type: TextInputType.number),
                    SizedBox(height: 18),
                    _campo("Estatura (cm)", Icons.height, _estaturaController,
                        type: TextInputType.number),
                  ],
                ),
              ),

              SizedBox(height: 35),

              // BOTÓN SIGUIENTE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 5, 103, 184),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: Text("Siguiente"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//PANTALLA DE EXPERIENCIA//

class ExperienciaPantalla extends StatefulWidget {
  @override
  _ExperienciaPantallaState createState() => _ExperienciaPantallaState();
}

class _ExperienciaPantallaState extends State<ExperienciaPantalla> {
  String _experiencia = '';

  void _cambiarMeta() async {
    if (_experiencia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor selecciona tu nivel de experiencia")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('experiencia', _experiencia);

    Navigator.pushReplacementNamed(context, "/meta");
  }

  Widget _chip(String label) {
    final bool activo = _experiencia == label;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: activo ? FontWeight.bold : FontWeight.normal,
          color: activo ? Colors.white : Colors.black87,
        ),
      ),
      selected: activo,
      selectedColor: Color.fromARGB(255, 50, 120, 185),
      backgroundColor: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (_) {
        setState(() {
          _experiencia = label;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Experiencia"),
        backgroundColor: Color.fromARGB(255, 50, 120, 185),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                SizedBox(height: 15),

                // LOGO
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 140,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // TARJETA
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Nivel de experiencia",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),

                      SizedBox(height: 25),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 15,
                        runSpacing: 15,
                        children: [
                          _chip("Bajo"),
                          _chip("Medio"),
                          _chip("Alto"),
                        ],
                      ),

                      SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _cambiarMeta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 50, 120, 185),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                          ),
                          child: Text("Siguiente"),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//PANTALLA DE META//


class MetaPantalla extends StatefulWidget {
  @override
  _MetaPantallaState createState() => _MetaPantallaState();
}

class _MetaPantallaState extends State<MetaPantalla> {
  String _meta = '';

  Future<void> _generarRutina() async {
    if (_meta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor selecciona tu meta")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('meta', _meta);
    await prefs.setBool('isRegistered', true);

    Navigator.pushNamedAndRemoveUntil(context, "/rutina", (route) => false);
  }

  Widget _chip(String label) {
    final bool active = _meta == label;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          color: active ? Colors.white : Colors.black87,
        ),
      ),
      selected: active,
      selectedColor: Color.fromARGB(255, 50, 120, 185),
      backgroundColor: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (_) {
        setState(() => _meta = label);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Meta"),
        backgroundColor: Color.fromARGB(255, 50, 120, 185),
        elevation: 2,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),

            child: Column(
              children: [
                SizedBox(height: 20),

                // LOGO
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 140,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // TARJETA BLANCA
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),

                  child: Column(
                    children: [
                      Text(
                        "¿Cuál es tu meta?",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),

                      SizedBox(height: 25),

                      Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          _chip("Perder peso"),
                          _chip("Ganar músculo"),
                          _chip("Mantenerse"),
                        ],
                      ),

                      SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _generarRutina,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromARGB(255, 50, 120, 185),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                          ),
                          child: Text("Generar rutina"),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//PANTALLA DE RUTINA//

class RutinaPantalla extends StatefulWidget {
  @override
  _RutinaPantallaState createState() => _RutinaPantallaState();
}

class _RutinaPantallaState extends State<RutinaPantalla> {
  String rutina = '';
  String meta = '';
  String nombre = '';

  @override
  void initState() {
    super.initState();
    _cargarRutina();
  }

  Future<void> _cargarRutina() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    meta = prefs.getString('meta') ?? 'Perder peso';
    nombre = prefs.getString('nombre') ?? 'Usuario';

    if (meta == 'Perder peso') {
      rutina = '''
Ejercicios para Perder Peso:
- Saltos Invertidos
- Skipping
- Sentadillas
- Mountain Climbers
- Abdominales
      ''';
    } else if (meta == 'Ganar músculo') {
      rutina = '''
Ejercicios para Ganar Músculo:
- Saltos Invertidos
- Sentadillas
- Abdominales
- Flexiones de brazos
- Fondos de triceps
      ''';
    } else if (meta == 'Mantenerse') {
      rutina = '''
Ejercicios para Mantenerse:
- Saltos Invertidos
- Flexiones de brazos
- Plancha con flexion
- Lunges o Zancadas
- Sentadillas
      ''';
    }

    setState(() {});
  }

  void _cambiarMeta() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MetaPantalla()),
    );
  }

  void _verProgreso() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgresoPantalla()),
    );
  }

  int calcularDuracionEjercicio(int edad, double peso, String experiencia) {
    int tiempoBase = 20;

    if (experiencia == 'Bajo') tiempoBase -= 5;
    if (experiencia == 'Medio') tiempoBase += 0;
    if (experiencia == 'Alto') tiempoBase += 10;

    if (edad > 40) tiempoBase -= 5;
    else if (edad < 25) tiempoBase += 5;

    if (peso > 90) tiempoBase -= 5;
    else if (peso < 60) tiempoBase += 5;

    if (tiempoBase < 10) tiempoBase = 10;

    return tiempoBase;
  }

  void _comenzarRutina() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int edad = int.parse(prefs.getString('edad') ?? '25');
    double peso = double.parse(prefs.getString('peso') ?? '70');
    String experiencia = prefs.getString('experiencia') ?? 'Medio';

    int tiempoRecomendado = calcularDuracionEjercicio(edad, peso, experiencia);

    List<Map<String, String>> ejercicios = [];

    if (meta == 'Perder peso') {
      ejercicios = [
        {'nombre': 'Saltos Invertidos', 'duracion': '$tiempoRecomendado', 'video': 'assets/jumping.mp4'},
        {'nombre': 'Skipping', 'duracion': '$tiempoRecomendado', 'video': 'assets/skipping.mp4'},
        {'nombre': 'Sentadillas', 'duracion': '$tiempoRecomendado', 'video': 'assets/sentadilla.mp4'},
        {'nombre': 'Mountain Climbers', 'duracion': '$tiempoRecomendado', 'video': 'assets/MountainC.mp4'},
        {'nombre': 'Abdominales', 'duracion': '$tiempoRecomendado', 'video': 'assets/abdominal.mp4'},
      ];
    } else if (meta == 'Ganar músculo') {
      ejercicios = [
        {'nombre': 'Saltos Invertidos', 'duracion': '$tiempoRecomendado', 'video': 'assets/jumping.mp4'},
        {'nombre': 'Sentadillas', 'duracion': '$tiempoRecomendado', 'video': 'assets/sentadilla.mp4'},
        {'nombre': 'Abdominales', 'duracion': '$tiempoRecomendado', 'video': 'assets/abdominal.mp4'},
        {'nombre': 'Flexiones de brazos', 'duracion': '$tiempoRecomendado', 'video': 'assets/flexiones.mp4'},
        {'nombre': 'Fondos de triceps', 'duracion': '$tiempoRecomendado', 'video': 'assets/triceps.mp4'},
      ];
    } else if (meta == 'Mantenerse') {
      ejercicios = [
        {'nombre': 'Saltos Invertidos', 'duracion': '$tiempoRecomendado', 'video': 'assets/jumping.mp4'},
        {'nombre': 'Flexiones de brazos', 'duracion': '$tiempoRecomendado', 'video': 'assets/flexiones.mp4'},
        {'nombre': 'Plancha con flexion', 'duracion': '$tiempoRecomendado', 'video': 'assets/plancha.mp4'},
        {'nombre': 'Lunges', 'duracion': '$tiempoRecomendado', 'video': 'assets/lunges.mp4'},
        {'nombre': 'Sentadillas', 'duracion': '$tiempoRecomendado', 'video': 'assets/sentadilla.mp4'},
      ];
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ComenzarRutinaPantalla(ejercicios: ejercicios),
        ),
      );
  }

 @override
    Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text("Rutina Personalizada - $nombre"),
      centerTitle: true,
      backgroundColor: Colors.indigo,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 20),

              // LOGO
              Image.asset("assets/logo.png", width: 120),

              SizedBox(height: 20),

              // TÍTULO PRINCIPAL
              Text(
                "Rutina para: $meta",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // TARJETA DE RUTINA
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ejercicios incluidos:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    rutina.isEmpty
                        ? Text(
                            "Cargando rutina...",
                            style: TextStyle(fontSize: 18),
                          )
                        : Text(
                            rutina,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                          ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // BOTÓN CAMBIAR META
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cambiarMeta,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo.shade50,
                    foregroundColor: Colors.indigo.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Cambiar Meta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // BOTÓN COMENZAR RUTINA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _comenzarRutina,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    "Comenzar Rutina",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // BOTÓN VER PROGRESO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verProgreso,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Ver Progreso",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );
  }}



// ============================
// PPANTALLA DE DESCANSO
// ============================


class DescansoPantalla extends StatefulWidget {
  final int siguienteIndice;
  final List<Map<String, String>> ejercicios;

  const DescansoPantalla({
    super.key,
    required this.siguienteIndice,
    required this.ejercicios,
  });

  @override
  State<DescansoPantalla> createState() => _DescansoPantallaState();
}

class _DescansoPantallaState extends State<DescansoPantalla> {
  int _tiempoRestante = 10;
  late Timer _timer;

  final List<String> frasesMotivadoras = [
    "Respira profundo…",
    "Recarga tu energía…",
    "Prepárate…",
    "Tu cuerpo puede, tu mente también.",
    "Vamos por el siguiente 📈",
  ];

  @override
  void initState() {
    super.initState();
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_tiempoRestante > 0) {
          _tiempoRestante--;
        } else {
          _timer.cancel();
          _continuarRutina();
        }
      });
    });
  }

  void _continuarRutina() {
    if (widget.siguienteIndice < widget.ejercicios.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ComenzarRutinaPantalla(
            ejercicios: widget.ejercicios,
            indiceActual: widget.siguienteIndice,
          ),
        ),
      );
    } else {
      _mostrarDialogoFinal();
    }
  }

  void _mostrarDialogoFinal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¡Rutina completada!"),
        content: const Text("Has terminado todos los ejercicios. 🎉"),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isRegistered', true);
              Navigator.pushNamedAndRemoveUntil(context, "/rutina", (route) => false);
            },
            child: const Text("Finalizar"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progreso = 1 - (_tiempoRestante / 10);
    String frase = frasesMotivadoras[_tiempoRestante % frasesMotivadoras.length];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // LOGO
                Image.asset('assets/logo.png', height: 110),
                const SizedBox(height: 40),

                // TITULO
                Text(
                  "Tiempo de descanso",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 40),

                // CONTADOR CIRCULAR
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: CircularProgressIndicator(
                        value: progreso,
                        strokeWidth: 12,
                        color: Colors.white,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    Text(
                      '$_tiempoRestante',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 45),

                // TARJETA GLASS
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 26),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    frase,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // TEXTO ADICIONAL
                const Text(
                  "Prepárate para el siguiente ejercicio",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ============================
// PANTALLA DE EJECUCIÓN DE RUTINA
// ============================


class ComenzarRutinaPantalla extends StatefulWidget {
  final List<Map<String, String>> ejercicios;
  final int indiceActual;

  const ComenzarRutinaPantalla({
    super.key,
    required this.ejercicios,
    this.indiceActual = 0,
  });

  @override
  State<ComenzarRutinaPantalla> createState() => _ComenzarRutinaPantallaState();
}

class _ComenzarRutinaPantallaState extends State<ComenzarRutinaPantalla> {
  late VideoPlayerController _videoController;
  late Timer _timer;
  int _tiempoRestante = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _pausado = false;

  @override
  void initState() {
    super.initState();
    _iniciarEjercicio();
  }

  void _iniciarEjercicio() {
    final ejercicioActual = widget.ejercicios[widget.indiceActual];
    _tiempoRestante = int.parse(ejercicioActual['duracion'] ?? '0');

    _videoController = VideoPlayerController.asset(ejercicioActual['video']!)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _iniciarTemporizador();
      });
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_pausado) return;

      if (_tiempoRestante > 0) {
        if (_tiempoRestante == 3) _reproducirTripleBeep();

        setState(() => _tiempoRestante--);
      } else {
        _timer.cancel();
        _videoController.pause();
        _irADescanso();
      }
    });
  }

  void _reproducirTripleBeep() async {
    _audioPlayer.play(AssetSource('beep.mp3'));
    Future.delayed(const Duration(milliseconds: 300), () {
      _audioPlayer.play(AssetSource('beep.mp3'));
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _audioPlayer.play(AssetSource('beep.mp3'));
    });
  }

  void _irADescanso() async {
    final siguiente = widget.indiceActual + 1;

    if (siguiente >= widget.ejercicios.length) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int dias = prefs.getInt('diasEntrenados') ?? 0;
      await prefs.setInt('diasEntrenados', dias + 1);
      await prefs.setBool('isRegistered', true);

      Navigator.pushNamedAndRemoveUntil(context, "/progreso", (route) => false);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DescansoPantalla(
          ejercicios: widget.ejercicios,
          siguienteIndice: siguiente,
        ),
      ),
    );
  }

  void _togglePausa() {
    setState(() {
      _pausado = !_pausado;
      if (_pausado) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ejercicio = widget.ejercicios[widget.indiceActual];

    double progreso =
        (_tiempoRestante / (int.parse(ejercicio['duracion'] ?? '1')))
            .clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // NOMBRE DEL EJERCICIO
              Text(
                ejercicio['nombre']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 25),

              // VIDEO DENTRO DE TARJETA
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 5))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _videoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          : const CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // TEMPORIZADOR CIRCULAR
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: progreso,
                      strokeWidth: 12,
                      color: Colors.greenAccent,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Text(
                    '$_tiempoRestante s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // BOTÓN PAUSA / REANUDAR
              GestureDetector(
                onTap: _togglePausa,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _pausado ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _pausado ? "Reanudar" : "Pausar",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}


//PANTALLA DE PROGRESO//


class ProgresoPantalla extends StatefulWidget {
  @override
  _ProgresoPantallaState createState() => _ProgresoPantallaState();
}

class _ProgresoPantallaState extends State<ProgresoPantalla> {
  int _diasEntrenados = 0;
  String _meta = '';
  double _porcentajeMeta = 0;

  @override
  void initState() {
    super.initState();
    _cargarProgreso();
  }

  Future<void> _cargarProgreso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _meta = prefs.getString('meta') ?? 'No definida';
      _diasEntrenados = prefs.getInt('diasEntrenados') ?? 0;
      _porcentajeMeta = (_diasEntrenados / 30) * 100;
    });
  }

  // -----------------------------
  // ❌ El botón de simular fue eliminado
  // -----------------------------

  // 🔘 Función para salir de la app
  void _salirAplicacion() {
    SystemNavigator.pop();   // Cierra la aplicación
  }

  // 🔘 Navegar a RutinaPantalla
  void _irARutina() {
    Navigator.pushNamedAndRemoveUntil(context, "/rutina", (route) => false);
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text("Tu Progreso"),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.indigo,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          
          // LOGO
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 120,
            ),
          ),
          SizedBox(height: 20),

          // TITULO
          Text(
            '¡Excelente trabajo!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          
          Text(
            "Has completado la Rutina (Día $_diasEntrenados)",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 30),

          // TARJETA DE PROGRESO
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Meta:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _meta,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.indigo,
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "Progreso del mes:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                LinearProgressIndicator(
                  value: _porcentajeMeta / 100,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                ),

                SizedBox(height: 10),

                Text(
                  '${_porcentajeMeta.toStringAsFixed(0)}% completado',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Días entrenados: $_diasEntrenados de 30",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // BOTONES
          Column(
            children: [
              // BOTÓN IR A RUTINA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _irARutina,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.indigo,
                    elevation: 4,
                  ),
                  child: Text(
                    "Ir a Rutina",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // BOTÓN SALIR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salirAplicacion,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 2,
                  ),
                  child: Text(
                    "Salir de la aplicación",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}