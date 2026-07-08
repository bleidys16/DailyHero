/// Contrato del sprite sheet compartido por TODAS las capas del avatar.
///
/// Cada capa (cuerpo, camisa, pantalón, casco, arma) es un PNG con el MISMO
/// layout: una grilla de [rows] x [columns] frames de [frameSize] px.
///
///   Filas (dirección):  0 = abajo, 1 = arriba, 2 = izquierda, 3 = derecha
///   Columnas (frames):  0..3  (0 = pose idle/parado, 0..3 = ciclo de caminar)
///
/// Para añadir más animaciones en el futuro (correr, atacar) basta con
/// agregar más filas/columnas y registrar el estado en [framesFor].
enum AvatarDirection { down, up, left, right }

enum AvatarState { idle, walk }

class AvatarLayout {
  const AvatarLayout._();

  /// Tamaño de cada frame en píxeles (nativo del arte, antes de escalar).
  static const double frameSize = 32;

  /// Columnas de frames por dirección (ciclo de caminar).
  static const int columns = 4;

  /// Filas = direcciones.
  static const int rows = 4;

  /// Fila del sheet para una dirección (coincide con el índice del enum).
  static int rowFor(AvatarDirection dir) => dir.index;

  /// Frames (columnas) que componen cada estado de animación.
  static List<int> framesFor(AvatarState state) {
    switch (state) {
      case AvatarState.idle:
        return const [0];
      case AvatarState.walk:
        return const [0, 1, 2, 3];
    }
  }

  /// Duración de cada frame según el estado.
  static double stepTimeFor(AvatarState state) {
    switch (state) {
      case AvatarState.idle:
        return 0.4;
      case AvatarState.walk:
        return 0.14;
    }
  }
}
