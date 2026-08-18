import '../models/program_model.dart';

const programs = [
  ProgramModel(
    id: 'jazz-morning',
    stationId: 'live-jazz',
    title: 'Jazz Matutino',
    description:
        'Comienza el día con una selección de jazz clásico y contemporáneo para relajarte y disfrutar de buena música.',
    schedule: 'Lunes a Viernes · 8:00 AM - 10:00 AM',
    imageUrl:
        'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=900',
    host: 'Carlos Mendoza',
  ),

  ProgramModel(
    id: 'smooth-evening',
    stationId: 'live-jazz',
    title: 'Smooth Evenings',
    description:
        'Una selección de smooth jazz perfecta para terminar el día.',
    schedule: 'Lunes a Viernes · 7:00 PM - 9:00 PM',
    imageUrl:
        'https://images.unsplash.com/photo-1501612780327-45045538702b?w=900',
    host: 'Ana Ruiz',
  ),

  ProgramModel(
    id: 'rock-zone',
    stationId: 'radioactiva',
    title: 'Rock Zone',
    description:
        'Los mejores clásicos del rock nacional e internacional.',
    schedule: 'Todos los días · 4:00 PM - 6:00 PM',
    imageUrl:
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=900',
    host: 'Luis García',
  ),

  ProgramModel(
    id: 'electro-night',
    stationId: 'radioactiva',
    title: 'Electro Night',
    description:
        'Sesiones con música electrónica para comenzar la noche.',
    schedule: 'Viernes y Sábado · 9:00 PM',
    imageUrl:
        'https://images.unsplash.com/photo-1498038432885-c6f3f1b912ee?w=900',
    host: 'DJ Nova',
  ),
];