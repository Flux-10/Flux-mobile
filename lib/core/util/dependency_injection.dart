import 'package:flutter/material.dart';
import 'package:flux/core/repo/auth_repository.dart';
import 'package:flux/core/services/api_client.dart';
import 'package:flux/core/util/api_config.dart';
import 'package:flux/features/Auth/bloc/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDependencies extends StatelessWidget {
  final Widget child;

  const AppDependencies({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ApiClient>(
          create: (_) => ApiClient(
            baseUrl: ApiConfig.baseUrl,
          ),
        ),
        
        // Repositories
        ProxyProvider<ApiClient, AuthRepository>(
          update: (_, apiClient, __) => AuthRepository(
            apiClient: apiClient,
          ),
        ),
        
        // BLoCs
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
} 