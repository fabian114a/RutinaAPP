import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  MyApp({required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutina App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isFirstTime ? BienvenidaPantalla() : RutinaPantalla(),
    );
  }
}



class BienvenidaPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 5, 103, 184), Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', width: 200), 
              SizedBox(height: 20),
              Text(
                'Bienvenido a Rutina App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isFirstTime', false);  // Marcar como no primer inicio
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroPantalla()),
                  );
                },
                child: Text('Comenzar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 225, 232, 238), // Color de fondo
                  foregroundColor: const Color.fromARGB(255, 117, 107, 212),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class RegistroPantalla extends StatefulWidget {
  @override
  _RegistroPantallaState createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();

  void _registrar() async {
    final nombre = _nombreController.text;
    final edad = _edadController.text;
    final peso = _pesoController.text;
    final estatura = _estaturaController.text;

    // Validaciones de datos numéricos
    if (nombre.isNotEmpty && edad.isNotEmpty && peso.isNotEmpty && estatura.isNotEmpty) {
      if (int.tryParse(edad) == null || double.tryParse(peso) == null || double.tryParse(estatura) == null) {
        print("Por favor, ingresa valores válidos para edad, peso y estatura.");
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('nombre', nombre);
      prefs.setString('edad', edad);
      prefs.setString('peso', peso);
      prefs.setString('estatura', estatura);
      prefs.setBool('isRegistered', true); // ← marca que ya se registró

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExperienciaPantalla()),
      );
    } else {
      print("Por favor, ingresa todos los datos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/logo.png', width: 150), 
            SizedBox(height: 20),
            // Campos de texto con validación y diseño
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _edadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _estaturaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Estatura (cm)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrar,
              child: Text('Siguiente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 50, 120, 185), // Color de fondo
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class ExperienciaPantalla extends StatefulWidget {
  @override
  _ExperienciaPantallaState createState() => _ExperienciaPantallaState();
}

class _ExperienciaPantallaState extends State<ExperienciaPantalla> {
  String _experiencia = '';

  // Función para navegar a la pantalla MetaPantalla
  void _cambiarMeta() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('experiencia', _experiencia); // 👈 Guarda la experiencia
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MetaPantalla()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Experiencia"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 1, 89, 160), Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Mostrar el logo en la parte superior
              Image.asset('assets/logo.png', width: 150),
              SizedBox(height: 20),

              // Mostrar texto "Nivel de experiencia:"
              Text(
                "Nivel de experiencia:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Selección de experiencia con ChoiceChip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ChoiceChip(
                    label: Text("Bajo"),
                    selected: _experiencia == 'Bajo',
                    onSelected: (selected) {
                      setState(() {
                        _experiencia = 'Bajo';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: Text("Medio"),
                    selected: _experiencia == 'Medio',
                    onSelected: (selected) {
                      setState(() {
                        _experiencia = 'Medio';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: Text("Alto"),
                    selected: _experiencia == 'Alto',
                    onSelected: (selected) {
                      setState(() {
                        _experiencia = 'Alto';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: const Color.fromARGB(255, 247, 247, 248),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Botón para cambiar de meta
              ElevatedButton(
                onPressed: _cambiarMeta,
                child: Text('Siguiente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 50, 120, 185), // Color de fondo
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









class MetaPantalla extends StatefulWidget {
  @override
  _MetaPantallaState createState() => _MetaPantallaState();
}

class _MetaPantallaState extends State<MetaPantalla> {
  String _meta = '';

  void _generarRutina() async {
    if ( _meta.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('meta', _meta);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RutinaPantalla()),
      );
    } else {
      print("Por favor, selecciona meta.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Meta"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 1, 89, 160), Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Mostrar el logo en la parte superior
              Image.asset('assets/logo.png', width: 150), // Asegúrate de tener el logo en assets
              SizedBox(height: 20), // Separar el logo de los demás elementos

             

              // Mostrar texto "Meta:"
              Text(
                "Meta:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10), // Separar del siguiente widget

              // Selección de meta con ChoiceChip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ChoiceChip(
                    label: Text("Perder peso"),
                    selected: _meta == 'Perder peso',
                    onSelected: (selected) {
                      setState(() {
                        _meta = 'Perder peso';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: Text("Ganar músculo"),
                    selected: _meta == 'Ganar músculo',
                    onSelected: (selected) {
                      setState(() {
                        _meta = 'Ganar músculo';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                  ),
                  ChoiceChip(
                    label: Text("Mantenerse"),
                    selected: _meta == 'Mantenerse',
                    onSelected: (selected) {
                      setState(() {
                        _meta = 'Mantenerse';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: const Color.fromARGB(255, 247, 247, 248),
                  ),
                ],
              ),
              SizedBox(height: 30), // Separar del siguiente widget

              // Botón para generar rutina
              ElevatedButton(
                onPressed: _generarRutina,
                child: Text('Generar Rutina'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 50, 120, 185), // Color de fondo
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}












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
- Burpees
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

  int calcularDuracionEjercicio(int edad, double peso, String experiencia) {
  int tiempoBase = 20; // tiempo base en segundos

  // Ajuste por experiencia
  if (experiencia == 'Bajo') tiempoBase -= 5;
  if (experiencia == 'Medio') tiempoBase += 0;
  if (experiencia == 'Alto') tiempoBase += 10;

  // Ajuste por edad
  if (edad > 40) tiempoBase -= 5;
  else if (edad < 25) tiempoBase += 5;

  // Ajuste por peso
  if (peso > 90) tiempoBase -= 5;
  else if (peso < 60) tiempoBase += 5;

  // Nunca menos de 10 segundos
  if (tiempoBase < 10) tiempoBase = 10;

  return tiempoBase;
}




  // ==========================
  // Iniciar rutina según meta
  // ==========================
  void _comenzarRutina() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int edad = int.parse(prefs.getString('edad') ?? '25');
    double peso = double.parse(prefs.getString('peso') ?? '70');
    String experiencia = prefs.getString('experiencia') ?? 'Medio';

    int tiempoRecomendado = calcularDuracionEjercicio(edad, peso, experiencia);


    List<Map<String, String>> ejercicios = [];

    if (meta == 'Perder peso') {
      ejercicios = [
        {'nombre': 'Saltos Invertidos', 'duracion': '$tiempoRecomendado', 'video': 'assets/jumping.mp4'},
        {'nombre': 'Burpees', 'duracion': '$tiempoRecomendado', 'video': 'assets/jumping.mp4'},
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
        {'nombre': 'Plancha con flexion', 'duracion': '$tiempoRecomendado', 'imagen': 'assets/plancha.mp4'},
        {'nombre': 'Lunges', 'duracion': '$tiempoRecomendado', 'video': 'assets/lunges.mp4'},
        {'nombre': 'Sentadillas', 'duracion': '$tiempoRecomendado', 'video': 'assets/sentadilla.mp4'},
      ];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComenzarRutinaPantalla(ejercicios: ejercicios),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rutina Personalizada - $nombre"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/logo.png', width: 150),
                const SizedBox(height: 20),
                Text(
                  'Rutina para: $meta',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  rutina.isEmpty ? 'Cargando rutina...' : rutina,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _cambiarMeta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 174, 196, 196),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Cambiar de Meta', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _comenzarRutina,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 225, 232, 240),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Comenzar Rutina', style: TextStyle(fontSize: 18)),
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
// PANTALLA DE DESCANSO
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
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 40),
              const Text("Tiempo de descanso", style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: progreso,
                      strokeWidth: 10,
                      color: Colors.blueAccent,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Text('$_tiempoRestante', style: const TextStyle(color: Colors.white, fontSize: 36)),
                ],
              ),
              const SizedBox(height: 40),
              const Text("Prepárate para el siguiente ejercicio",
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
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

  @override
  void initState() {
    super.initState();
    _iniciarEjercicio();
  }

  void _iniciarEjercicio() {
    final ejercicioActual = widget.ejercicios[widget.indiceActual];
    _tiempoRestante = int.tryParse(ejercicioActual['duracion'] ?? '0') ?? 0;

    _videoController = VideoPlayerController.asset(ejercicioActual['video']!)
      ..setLooping(true) // 👈 Reproduce en bucle
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _iniciarTemporizador();
      });
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tiempoRestante > 0) {
        setState(() => _tiempoRestante--);
      } else {
        _timer.cancel();
        _videoController.pause();
        _irADescanso();
      }
    });
  }

  void _irADescanso() {
    final siguienteIndice = widget.indiceActual + 1;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DescansoPantalla(
          ejercicios: widget.ejercicios,
          siguienteIndice: siguienteIndice,
        ),
      ),
    );
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
    double progreso = (_tiempoRestante / (int.tryParse(ejercicio['duracion'] ?? '1') ?? 1)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(ejercicio['nombre']!, style: const TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progreso,
                    strokeWidth: 10,
                    color: Colors.greenAccent,
                    backgroundColor: Colors.white24,
                  ),
                ),
                Text('$_tiempoRestante s', style: const TextStyle(color: Colors.white, fontSize: 24)),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}