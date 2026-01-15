// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce_flutter/hive_flutter.dart' as _i919;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:uuid/uuid.dart' as _i706;

import 'core/network/network_info.dart' as _i75;
import 'features/authentication/data/datasources/auth_local_datasource.dart'
    as _i976;
import 'features/authentication/data/datasources/auth_remote_datasource.dart'
    as _i732;
import 'features/authentication/data/repositories/auth_repository_impl.dart'
    as _i446;
import 'features/authentication/domain/repositories/auth_repository.dart'
    as _i877;
import 'features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i804;
import 'features/authentication/domain/usecases/reset_password_usecase.dart'
    as _i534;
import 'features/authentication/domain/usecases/sign_in_usecase.dart' as _i139;
import 'features/authentication/domain/usecases/sign_out_usecase.dart' as _i819;
import 'features/authentication/domain/usecases/sign_up_usecase.dart' as _i200;
import 'features/authentication/presentation/bloc/auth_bloc.dart' as _i706;
import 'features/chat/data/datasources/chat_local_datasource.dart' as _i161;
import 'features/chat/data/datasources/chat_remote_datasource.dart' as _i343;
import 'features/chat/data/repositories/chat_repository_impl.dart' as _i382;
import 'features/chat/domain/repositories/chat_repository.dart' as _i453;
import 'features/chat/domain/usecases/add_reaction_usecase.dart' as _i842;
import 'features/chat/domain/usecases/delete_message_usecase.dart' as _i402;
import 'features/chat/domain/usecases/get_messages_usecase.dart' as _i350;
import 'features/chat/domain/usecases/get_or_create_chat_usecase.dart' as _i900;
import 'features/chat/domain/usecases/get_user_chats_usecase.dart' as _i537;
import 'features/chat/domain/usecases/mark_as_read_usecase.dart' as _i58;
import 'features/chat/domain/usecases/send_message_usecase.dart' as _i72;
import 'features/chat/domain/usecases/send_typing_indicator_usecase.dart'
    as _i470;
import 'features/chat/presentation/bloc/chat_list/chat_list_bloc.dart' as _i458;
import 'features/chat/presentation/bloc/chat_room/chat_room_bloc.dart' as _i720;
import 'features/media/data/datasources/storage_remote_datasource.dart'
    as _i441;
import 'features/media/data/repositories/storage_repository_impl.dart' as _i71;
import 'features/media/domain/repositories/storage_repository.dart' as _i13;
import 'features/media/domain/usecases/upload_file_usecase.dart' as _i406;
import 'features/media/domain/usecases/upload_image_usecase.dart' as _i1058;
import 'features/media/domain/usecases/upload_voice_usecase.dart' as _i874;
import 'features/user_profile/data/datasources/profile_remote_datasource.dart'
    as _i1004;
import 'features/user_profile/data/repositories/profile_repository_impl.dart'
    as _i898;
import 'features/user_profile/domain/repositories/profile_repository.dart'
    as _i204;
import 'features/user_profile/domain/usecases/get_profile_usecase.dart'
    as _i301;
import 'features/user_profile/domain/usecases/update_avatar_usecase.dart'
    as _i498;
import 'features/user_profile/domain/usecases/update_profile_usecase.dart'
    as _i909;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i441.StorageRemoteDataSource>(
      () => _i441.StorageRemoteDataSourceImpl(
        storage: gh<_i457.FirebaseStorage>(),
        uuid: gh<_i706.Uuid>(),
      ),
    );
    gh.lazySingleton<_i13.StorageRepository>(
      () => _i71.StorageRepositoryImpl(
        remoteDataSource: gh<_i441.StorageRemoteDataSource>(),
        networkInfo: gh<_i75.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i976.AuthLocalDataSource>(
      () => _i976.AuthLocalDataSourceImpl(
        gh<_i919.Box<dynamic>>(instanceName: 'usersBox'),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i161.ChatLocalDataSource>(
      () => _i161.ChatLocalDataSourceImpl(
        gh<_i919.Box<dynamic>>(instanceName: 'messagesBox'),
        gh<_i919.Box<dynamic>>(instanceName: 'chatsBox'),
        gh<_i919.Box<dynamic>>(instanceName: 'queuedMessagesBox'),
      ),
    );
    gh.lazySingleton<_i343.ChatRemoteDataSource>(
      () => _i343.ChatRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i1004.ProfileRemoteDataSource>(
      () => _i1004.ProfileRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i204.ProfileRepository>(
      () => _i898.ProfileRepositoryImpl(
        remoteDataSource: gh<_i1004.ProfileRemoteDataSource>(),
        storageRepository: gh<_i13.StorageRepository>(),
        networkInfo: gh<_i75.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i732.AuthRemoteDataSource>(
      () => _i732.AuthRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i406.UploadFileUseCase>(
      () => _i406.UploadFileUseCase(gh<_i13.StorageRepository>()),
    );
    gh.lazySingleton<_i1058.UploadImageUseCase>(
      () => _i1058.UploadImageUseCase(gh<_i13.StorageRepository>()),
    );
    gh.lazySingleton<_i874.UploadVoiceUseCase>(
      () => _i874.UploadVoiceUseCase(gh<_i13.StorageRepository>()),
    );
    gh.lazySingleton<_i301.GetProfileUseCase>(
      () => _i301.GetProfileUseCase(gh<_i204.ProfileRepository>()),
    );
    gh.lazySingleton<_i498.UpdateAvatarUseCase>(
      () => _i498.UpdateAvatarUseCase(gh<_i204.ProfileRepository>()),
    );
    gh.lazySingleton<_i909.UpdateProfileUseCase>(
      () => _i909.UpdateProfileUseCase(gh<_i204.ProfileRepository>()),
    );
    gh.lazySingleton<_i453.ChatRepository>(
      () => _i382.ChatRepositoryImpl(
        remoteDataSource: gh<_i343.ChatRemoteDataSource>(),
        localDataSource: gh<_i161.ChatLocalDataSource>(),
        networkInfo: gh<_i75.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i877.AuthRepository>(
      () => _i446.AuthRepositoryImpl(
        remoteDataSource: gh<_i732.AuthRemoteDataSource>(),
        localDataSource: gh<_i976.AuthLocalDataSource>(),
        networkInfo: gh<_i75.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i842.AddReactionUseCase>(
      () => _i842.AddReactionUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i402.DeleteMessageUseCase>(
      () => _i402.DeleteMessageUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i350.GetMessagesUseCase>(
      () => _i350.GetMessagesUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i900.GetOrCreateChatUseCase>(
      () => _i900.GetOrCreateChatUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i537.GetUserChatsUseCase>(
      () => _i537.GetUserChatsUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i58.MarkAsReadUseCase>(
      () => _i58.MarkAsReadUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i72.SendMessageUseCase>(
      () => _i72.SendMessageUseCase(gh<_i453.ChatRepository>()),
    );
    gh.lazySingleton<_i470.SendTypingIndicatorUseCase>(
      () => _i470.SendTypingIndicatorUseCase(gh<_i453.ChatRepository>()),
    );
    gh.factory<_i720.ChatRoomBloc>(
      () => _i720.ChatRoomBloc(
        getMessagesUseCase: gh<_i350.GetMessagesUseCase>(),
        sendMessageUseCase: gh<_i72.SendMessageUseCase>(),
        deleteMessageUseCase: gh<_i402.DeleteMessageUseCase>(),
        markAsReadUseCase: gh<_i58.MarkAsReadUseCase>(),
        sendTypingIndicatorUseCase: gh<_i470.SendTypingIndicatorUseCase>(),
      ),
    );
    gh.lazySingleton<_i804.GetCurrentUserUseCase>(
      () => _i804.GetCurrentUserUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i534.ResetPasswordUseCase>(
      () => _i534.ResetPasswordUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i139.SignInUseCase>(
      () => _i139.SignInUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i819.SignOutUseCase>(
      () => _i819.SignOutUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i200.SignUpUseCase>(
      () => _i200.SignUpUseCase(gh<_i877.AuthRepository>()),
    );
    gh.factory<_i458.ChatListBloc>(
      () => _i458.ChatListBloc(
        getUserChatsUseCase: gh<_i537.GetUserChatsUseCase>(),
      ),
    );
    gh.factory<_i706.AuthBloc>(
      () => _i706.AuthBloc(
        signInUseCase: gh<_i139.SignInUseCase>(),
        signUpUseCase: gh<_i200.SignUpUseCase>(),
        signOutUseCase: gh<_i819.SignOutUseCase>(),
        getCurrentUserUseCase: gh<_i804.GetCurrentUserUseCase>(),
        resetPasswordUseCase: gh<_i534.ResetPasswordUseCase>(),
      ),
    );
    return this;
  }
}
