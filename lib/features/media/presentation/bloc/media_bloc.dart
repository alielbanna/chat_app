import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';
import '../../domain/usecases/upload_voice_usecase.dart';
import 'media_event.dart';
import 'media_state.dart';

@injectable
class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final UploadImageUseCase uploadImageUseCase;
  final UploadFileUseCase uploadFileUseCase;
  final UploadVoiceUseCase uploadVoiceUseCase;
  final ImagePicker imagePicker;

  MediaBloc({
    required this.uploadImageUseCase,
    required this.uploadFileUseCase,
    required this.uploadVoiceUseCase,
    required this.imagePicker,
  }) : super(const MediaInitial()) {
    on<MediaImagePickRequested>(_onImagePickRequested);
    on<MediaFilePickRequested>(_onFilePickRequested);
    on<MediaImageUploadRequested>(_onImageUploadRequested);
    on<MediaFileUploadRequested>(_onFileUploadRequested);
    on<MediaVoiceUploadRequested>(_onVoiceUploadRequested);
  }

  Future<void> _onImagePickRequested(
      MediaImagePickRequested event,
      Emitter<MediaState> emit,
      ) async {
    try {
      emit(const MediaPicking());

      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        emit(const MediaInitial());
        return;
      }

      AppLogger.info('Image picked: ${image.path}');
      emit(const MediaInitial());
    } catch (e) {
      AppLogger.error('Pick image error', e);
      emit(MediaError(message: e.toString()));
    }
  }

  Future<void> _onFilePickRequested(
      MediaFilePickRequested event,
      Emitter<MediaState> emit,
      ) async {
    try {
      emit(const MediaPicking());

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result == null || result.files.isEmpty) {
        emit(const MediaInitial());
        return;
      }

      AppLogger.info('File picked: ${result.files.first.path}');
      emit(const MediaInitial());
    } catch (e) {
      AppLogger.error('Pick file error', e);
      emit(MediaError(message: e.toString()));
    }
  }

  Future<void> _onImageUploadRequested(
      MediaImageUploadRequested event,
      Emitter<MediaState> emit,
      ) async {
    emit(const MediaUploading(progress: 0));

    final result = await uploadImageUseCase(
      UploadImageParams(
        filePath: event.filePath,
        folder: '${FirebaseConstants.chatImagesPath}/${event.chatId}',
        onProgress: (progress) {
          emit(MediaUploading(progress: progress));
        },
      ),
    );

    result.fold(
          (failure) {
        AppLogger.error('Upload image failed', failure.message);
        emit(MediaError(message: failure.message));
      },
          (media) {
        AppLogger.info('Image uploaded successfully');
        emit(MediaUploadSuccess(media: media));
      },
    );
  }

  Future<void> _onFileUploadRequested(
      MediaFileUploadRequested event,
      Emitter<MediaState> emit,
      ) async {
    emit(const MediaUploading(progress: 0));

    final result = await uploadFileUseCase(
      UploadFileParams(
        filePath: event.filePath,
        folder: '${FirebaseConstants.chatFilesPath}/${event.chatId}',
        onProgress: (progress) {
          emit(MediaUploading(progress: progress));
        },
      ),
    );

    result.fold(
          (failure) {
        AppLogger.error('Upload file failed', failure.message);
        emit(MediaError(message: failure.message));
      },
          (media) {
        AppLogger.info('File uploaded successfully');
        emit(MediaUploadSuccess(media: media));
      },
    );
  }

  Future<void> _onVoiceUploadRequested(
      MediaVoiceUploadRequested event,
      Emitter<MediaState> emit,
      ) async {
    emit(const MediaUploading(progress: 0));

    final result = await uploadVoiceUseCase(
      UploadVoiceParams(
        filePath: event.filePath,
        duration: event.duration,
        onProgress: (progress) {
          emit(MediaUploading(progress: progress));
        },
      ),
    );

    result.fold(
          (failure) {
        AppLogger.error('Upload voice failed', failure.message);
        emit(MediaError(message: failure.message));
      },
          (media) {
        AppLogger.info('Voice uploaded successfully');
        emit(MediaUploadSuccess(media: media));
      },
    );
  }
}