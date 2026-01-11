#!/bin/bash

echo "🚀 Creating Flutter Chat App Structure..."

# Create all directories
mkdir -p lib/{core/{constants,errors,network,utils,usecases,theme},features/{authentication/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}},chat/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc/{chat_list,chat_room,message},pages,widgets}},media/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,widgets}},user_profile/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}},config/{routes,environment}}

# Main app files
touch lib/main.dart
touch lib/app.dart
touch lib/injection.dart

# Core - Constants
touch lib/core/constants/app_constants.dart
touch lib/core/constants/firebase_constants.dart
touch lib/core/constants/storage_keys.dart

# Core - Errors
touch lib/core/errors/failures.dart
touch lib/core/errors/exceptions.dart

# Core - Network
touch lib/core/network/network_info.dart
touch lib/core/network/api_client.dart

# Core - Utils
touch lib/core/utils/logger.dart
touch lib/core/utils/date_formatter.dart
touch lib/core/utils/validators.dart
touch lib/core/utils/encryption_helper.dart

# Core - UseCases
touch lib/core/usecases/usecase.dart

# Core - Theme
touch lib/core/theme/app_theme.dart
touch lib/core/theme/app_colors.dart
touch lib/core/theme/app_text_styles.dart

# Config
touch lib/config/routes/app_router.dart
touch lib/config/routes/route_names.dart
touch lib/config/environment/env_config.dart

# ========== AUTHENTICATION FEATURE ==========

# Auth - Data Layer
touch lib/features/authentication/data/datasources/auth_remote_datasource.dart
touch lib/features/authentication/data/datasources/auth_local_datasource.dart
touch lib/features/authentication/data/models/user_model.dart
touch lib/features/authentication/data/repositories/auth_repository_impl.dart

# Auth - Domain Layer
touch lib/features/authentication/domain/entities/user_entity.dart
touch lib/features/authentication/domain/repositories/auth_repository.dart
touch lib/features/authentication/domain/usecases/sign_in_usecase.dart
touch lib/features/authentication/domain/usecases/sign_up_usecase.dart
touch lib/features/authentication/domain/usecases/sign_out_usecase.dart
touch lib/features/authentication/domain/usecases/get_current_user_usecase.dart

# Auth - Presentation Layer
touch lib/features/authentication/presentation/bloc/auth_bloc.dart
touch lib/features/authentication/presentation/bloc/auth_event.dart
touch lib/features/authentication/presentation/bloc/auth_state.dart
touch lib/features/authentication/presentation/pages/login_page.dart
touch lib/features/authentication/presentation/pages/register_page.dart
touch lib/features/authentication/presentation/pages/splash_page.dart
touch lib/features/authentication/presentation/widgets/auth_text_field.dart
touch lib/features/authentication/presentation/widgets/auth_button.dart

# ========== CHAT FEATURE ==========

# Chat - Data Layer
touch lib/features/chat/data/datasources/chat_remote_datasource.dart
touch lib/features/chat/data/datasources/chat_local_datasource.dart
touch lib/features/chat/data/models/message_model.dart
touch lib/features/chat/data/models/chat_model.dart
touch lib/features/chat/data/models/typing_indicator_model.dart
touch lib/features/chat/data/repositories/chat_repository_impl.dart

# Chat - Domain Layer
touch lib/features/chat/domain/entities/message_entity.dart
touch lib/features/chat/domain/entities/chat_entity.dart
touch lib/features/chat/domain/repositories/chat_repository.dart
touch lib/features/chat/domain/usecases/send_message_usecase.dart
touch lib/features/chat/domain/usecases/get_messages_usecase.dart
touch lib/features/chat/domain/usecases/send_typing_indicator_usecase.dart
touch lib/features/chat/domain/usecases/mark_as_read_usecase.dart
touch lib/features/chat/domain/usecases/delete_message_usecase.dart
touch lib/features/chat/domain/usecases/get_or_create_chat_usecase.dart
touch lib/features/chat/domain/usecases/get_user_chats_usecase.dart
touch lib/features/chat/domain/usecases/add_reaction_usecase.dart

# Chat - Presentation Layer - Chat List
touch lib/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart
touch lib/features/chat/presentation/bloc/chat_list/chat_list_event.dart
touch lib/features/chat/presentation/bloc/chat_list/chat_list_state.dart

# Chat - Presentation Layer - Chat Room
touch lib/features/chat/presentation/bloc/chat_room/chat_room_bloc.dart
touch lib/features/chat/presentation/bloc/chat_room/chat_room_event.dart
touch lib/features/chat/presentation/bloc/chat_room/chat_room_state.dart

# Chat - Presentation Layer - Message
touch lib/features/chat/presentation/bloc/message/message_bloc.dart
touch lib/features/chat/presentation/bloc/message/message_event.dart
touch lib/features/chat/presentation/bloc/message/message_state.dart

# Chat - Presentation Layer - Pages & Widgets
touch lib/features/chat/presentation/pages/chat_list_page.dart
touch lib/features/chat/presentation/pages/chat_room_page.dart
touch lib/features/chat/presentation/pages/user_search_page.dart
touch lib/features/chat/presentation/widgets/message_bubble.dart
touch lib/features/chat/presentation/widgets/chat_input.dart
touch lib/features/chat/presentation/widgets/typing_indicator.dart
touch lib/features/chat/presentation/widgets/message_reactions.dart
touch lib/features/chat/presentation/widgets/chat_list_tile.dart
touch lib/features/chat/presentation/widgets/user_avatar.dart

# ========== MEDIA FEATURE ==========

# Media - Data Layer
touch lib/features/media/data/datasources/storage_remote_datasource.dart
touch lib/features/media/data/models/media_model.dart
touch lib/features/media/data/repositories/storage_repository_impl.dart

# Media - Domain Layer
touch lib/features/media/domain/entities/media_entity.dart
touch lib/features/media/domain/repositories/storage_repository.dart
touch lib/features/media/domain/usecases/upload_image_usecase.dart
touch lib/features/media/domain/usecases/upload_file_usecase.dart
touch lib/features/media/domain/usecases/upload_voice_usecase.dart

# Media - Presentation Layer
touch lib/features/media/presentation/bloc/media_bloc.dart
touch lib/features/media/presentation/bloc/media_event.dart
touch lib/features/media/presentation/bloc/media_state.dart
touch lib/features/media/presentation/widgets/image_picker_bottom_sheet.dart
touch lib/features/media/presentation/widgets/voice_recorder_widget.dart
touch lib/features/media/presentation/widgets/file_preview.dart

# ========== USER PROFILE FEATURE ==========

# User Profile - Data Layer
touch lib/features/user_profile/data/datasources/profile_remote_datasource.dart
touch lib/features/user_profile/data/models/profile_model.dart
touch lib/features/user_profile/data/repositories/profile_repository_impl.dart

# User Profile - Domain Layer
touch lib/features/user_profile/domain/entities/profile_entity.dart
touch lib/features/user_profile/domain/repositories/profile_repository.dart
touch lib/features/user_profile/domain/usecases/get_profile_usecase.dart
touch lib/features/user_profile/domain/usecases/update_profile_usecase.dart
touch lib/features/user_profile/domain/usecases/update_avatar_usecase.dart

# User Profile - Presentation Layer
touch lib/features/user_profile/presentation/bloc/profile_bloc.dart
touch lib/features/user_profile/presentation/bloc/profile_event.dart
touch lib/features/user_profile/presentation/bloc/profile_state.dart
touch lib/features/user_profile/presentation/pages/profile_page.dart
touch lib/features/user_profile/presentation/pages/edit_profile_page.dart
touch lib/features/user_profile/presentation/widgets/profile_avatar.dart
touch lib/features/user_profile/presentation/widgets/profile_info_tile.dart

echo ""
echo "✅ Flutter Chat App structure created successfully!"
echo ""
echo "📁 Created structure:"
echo "   - Core (constants, errors, network, utils, usecases, theme)"
echo "   - Features:"
echo "     • Authentication (login, register, splash)"
echo "     • Chat (messages, chat list, chat room)"
echo "     • Media (image, file, voice upload)"
echo "     • User Profile (view, edit profile)"
echo "   - Config (routes, environment)"
echo ""
