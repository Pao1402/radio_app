import '../models/program_model.dart';
import '../models/station_model.dart';

const List<StationModel> stations = [
  StationModel(
    id: 'live_jazz_radio',
    name: 'Live Jazz Radio',
    acronym: 'LJR',
    streamUrl: 'https://stream.freepi.io/8012/live',
    imageUrl:
        'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f',
    slogan: 'La síncopa de nuestras latitudes',

    websiteUrl: 'https://freepi.io',
    facebookUrl: 'https://facebook.com',
    instagramUrl: 'https://instagram.com',
    youtubeUrl: 'https://youtube.com',
  ),

  StationModel(
    id: 'radioactiva_tx',
    name: 'Radioactiva Tx',
    acronym: 'RTX',
    streamUrl: 'https://stream.freepi.io/8010/stream',
    imageUrl:
        'https://images.unsplash.com/photo-1598387993281-cecf8b71a8f8',
    slogan: '¡La Radio Alternativa!',

    websiteUrl: 'https://freepi.io',
    facebookUrl: 'https://facebook.com',
    instagramUrl: 'https://instagram.com',
    youtubeUrl: 'https://youtube.com',
  ),
];

const List<ProgramModel> programs = [
  ProgramModel(
    id: 'jazz_matutino',
    stationId: 'live_jazz_radio',
    title: 'Jazz Matutino',
    description:
        'Una selección de jazz para comenzar el día con ritmo y tranquilidad.',
    schedule: 'Lunes a viernes · 8:00 a. m.',
    imageUrl:
        'https://images.unsplash.com/photo-1511192336575-5a79af67a629',
    host: 'Live Jazz Radio',
  ),
  ProgramModel(
    id: 'noches_de_jazz',
    stationId: 'live_jazz_radio',
    title: 'Noches de Jazz',
    description:
        'Clásicos, nuevas propuestas y sesiones especiales de jazz.',
    schedule: 'Viernes · 9:00 p. m.',
    imageUrl:
        'https://images.unsplash.com/photo-1483412033650-1015ddeb83d1',
    host: 'Live Jazz Radio',
  ),
  ProgramModel(
    id: 'radio_alternativa',
    stationId: 'radioactiva_tx',
    title: 'Radio Alternativa',
    description:
        'Música alternativa, noticias y recomendaciones independientes.',
    schedule: 'Lunes a viernes · 6:00 p. m.',
    imageUrl:
        'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b',
    host: 'Radioactiva Tx',
  ),
  ProgramModel(
    id: 'sesion_tx',
    stationId: 'radioactiva_tx',
    title: 'Sesión TX',
    description:
        'Una sesión dedicada a bandas, artistas y sonidos emergentes.',
    schedule: 'Sábados · 7:00 p. m.',
    imageUrl:
        'https://images.unsplash.com/photo-1524650359799-842906ca1c06',
    host: 'Radioactiva Tx',
  ),
];