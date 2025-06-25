import 'package:flutter/material.dart';
import '../models/favorite_model.dart';
import '../widgets/favorite_button.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor actor;

  const ActorDetailScreen({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF121212),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    actor.profileUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              FavoriteButton(actor: actor, size: 28, color: Colors.white),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (actor.birthDate.isNotEmpty || actor.birthPlace.isNotEmpty)
                    Row(
                      children: [
                        if (actor.birthDate.isNotEmpty) ...[
                          const Icon(Icons.cake, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            actor.birthDate,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                        if (actor.birthDate.isNotEmpty &&
                            actor.birthPlace.isNotEmpty)
                          const Text(
                            ' • ',
                            style: TextStyle(color: Colors.grey),
                          ),
                        if (actor.birthPlace.isNotEmpty) ...[
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              actor.birthPlace,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (actor.biography.isNotEmpty) ...[
                    const Text(
                      'Tiểu sử',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actor.biography,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (actor.knownFor.isNotEmpty) ...[
                    const Text(
                      'Nổi tiếng với',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          actor.knownFor.map((movie) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                movie,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
