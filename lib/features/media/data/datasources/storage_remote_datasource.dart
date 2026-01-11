import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/media_model.dart';

abstract class StorageRemoteDataSource {
  Future<MediaModel> uploadImage({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  });

  Future<MediaModel> uploadFile({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  });

  Future<MediaModel> uploadVoice({
    required String filePath,
    required int duration,
    Function(double)? onProgress,
  });

  Future<void> deleteFile(String fileUrl);
  Future<String> getDownloadUrl(String filePath);
}

@LazySingleton(as: StorageRemoteDataSource)
class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  final FirebaseStorage storage;
  final Uuid uuid;

  StorageRemoteDataSourceImpl({
    required this.storage,
    required this.uuid,
  });

  @override
  Future<MediaModel> uploadImage({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const FileException('File does not exist');
      }

      final fileSize = await file.length();
      final fileName = path.basename(filePath);
      final fileId = uuid.v4();
      final extension = path.extension(filePath);
      final storagePath = '$folder/$fileId$extension';

      final ref = storage.ref().child(storagePath);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/${extension.replaceAll('.', '')}'),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogger.info('Image uploaded successfully: $downloadUrl');

      return MediaModel(
        id: fileId,
        url: downloadUrl,
        fileName: fileName,
        fileSize: fileSize,
        type: MediaType.image,
        uploadedAt: DateTime.now(),
      );
    } on FirebaseException catch (e) {
      AppLogger.error('Upload image error', e);
      throw FileException(e.message ?? 'Upload failed');
    } catch (e) {
      AppLogger.error('Upload image error', e);
      throw FileException(e.toString());
    }
  }

  @override
  Future<MediaModel> uploadFile({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const FileException('File does not exist');
      }

      final fileSize = await file.length();
      final fileName = path.basename(filePath);
      final fileId = uuid.v4();
      final extension = path.extension(filePath);
      final storagePath = '$folder/$fileId$extension';

      final ref = storage.ref().child(storagePath);
      final uploadTask = ref.putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogger.info('File uploaded successfully: $downloadUrl');

      return MediaModel(
        id: fileId,
        url: downloadUrl,
        fileName: fileName,
        fileSize: fileSize,
        type: MediaType.file,
        uploadedAt: DateTime.now(),
      );
    } on FirebaseException catch (e) {
      AppLogger.error('Upload file error', e);
      throw FileException(e.message ?? 'Upload failed');
    } catch (e) {
      AppLogger.error('Upload file error', e);
      throw FileException(e.toString());
    }
  }

  @override
  Future<MediaModel> uploadVoice({
    required String filePath,
    required int duration,
    Function(double)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const FileException('File does not exist');
      }

      final fileSize = await file.length();
      final fileName = path.basename(filePath);
      final fileId = uuid.v4();
      final storagePath = '${FirebaseConstants.voiceMessagesPath}/$fileId.m4a';

      final ref = storage.ref().child(storagePath);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: 'audio/m4a'),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogger.info('Voice message uploaded successfully: $downloadUrl');

      return MediaModel(
        id: fileId,
        url: downloadUrl,
        fileName: fileName,
        fileSize: fileSize,
        type: MediaType.voice,
        duration: duration,
        uploadedAt: DateTime.now(),
      );
    } on FirebaseException catch (e) {
      AppLogger.error('Upload voice error', e);
      throw FileException(e.message ?? 'Upload failed');
    } catch (e) {
      AppLogger.error('Upload voice error', e);
      throw FileException(e.toString());
    }
  }

  @override
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = storage.refFromURL(fileUrl);
      await ref.delete();
      AppLogger.info('File deleted successfully: $fileUrl');
    } on FirebaseException catch (e) {
      AppLogger.error('Delete file error', e);
      throw FileException(e.message ?? 'Delete failed');
    } catch (e) {
      AppLogger.error('Delete file error', e);
      throw FileException(e.toString());
    }
  }

  @override
  Future<String> getDownloadUrl(String filePath) async {
    try {
      final ref = storage.ref().child(filePath);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      AppLogger.error('Get download URL error', e);
      throw FileException(e.message ?? 'Get URL failed');
    } catch (e) {
      AppLogger.error('Get download URL error', e);
      throw FileException(e.toString());
    }
  }
}