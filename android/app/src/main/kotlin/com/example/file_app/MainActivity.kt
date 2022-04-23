package com.example.file_app

import android.Manifest.permission.READ_EXTERNAL_STORAGE
import android.content.ContentUris
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Build.VERSION.SDK_INT
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import android.util.Size
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
    
    private val channel = "samples.flutter.dev/battery"

    private val videoProjection = arrayOf(
        MediaStore.Video.Media._ID,
        MediaStore.Video.Media.DISPLAY_NAME,
    MediaStore.Video.Media.DURATION,
    MediaStore.Video.Media.SIZE,
        MediaStore.Video.Media.DATE_TAKEN
    )

    private val downloadProjection = arrayOf(
        MediaStore.Downloads._ID,
        MediaStore.Downloads.DISPLAY_NAME,
        MediaStore.Downloads.DURATION,
        MediaStore.Downloads.SIZE,
        MediaStore.Downloads.DATE_TAKEN
    )

    private val imageProjection = arrayOf(
        MediaStore.Images.Media._ID,
        MediaStore.Images.Media.DISPLAY_NAME,
        "",
        MediaStore.Images.Media.SIZE,
        MediaStore.Video.Media.DATE_TAKEN,
    )

    private val audioProjection: Array<String> = arrayOf(
        MediaStore.Audio.Media._ID,
        MediaStore.Audio.Media.DISPLAY_NAME,
        MediaStore.Audio.Media.DURATION,
        MediaStore.Audio.Media.SIZE,
        MediaStore.Video.Media.DATE_TAKEN
    )

    private val fileProjections = arrayOf(
        MediaStore.Files.FileColumns._ID,
        MediaStore.Files.FileColumns.DISPLAY_NAME,
        MediaStore.Files.FileColumns.DURATION,
        MediaStore.Files.FileColumns.SIZE,
        MediaStore.Files.FileColumns.DATE_TAKEN,
                MediaStore.Files.FileColumns.MIME_TYPE
    )

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
       call, result ->
      if (call.method == "getFiles") {
          val successCB :(MutableList<Map<String, String>>)-> Unit ={
          }
          val failureCB :(String)-> Unit ={
          }

          val type = call.argument<String>("type")
          if(type != null){
              runSearch(result, getProjections(type), getExternalContentUri(type), successCB, failureCB)
          }
          else{
              result.error("type unsupported", "type invalid", "File type has to be given")
          }
      }
        if (call.method == "getThumbnail") {
            val uri = call.argument<String>("uri")
            val id = call.argument<String>("id")?.toLong()
            if(uri != null && id != null){
                getThumbnail(result, uri, id)
            }
            else{
                result.error("type unsupported", "type invalid", "File type has to be given")
            }
        }
        if (call.method == "deleteFile") {
            val uri = call.argument<String>("uri")
            val id = call.argument<String>("id")?.toLong()
            if(uri != null && id != null){
                var deletedFiles = 0;
                if (SDK_INT >= Build.VERSION_CODES.R) {
                    deletedFiles = contentResolver.delete(Uri.parse(uri), null)
                }
                else{
                    deletedFiles = contentResolver.delete(Uri.parse(uri), null, null)
                }

                result.success(deletedFiles==1)
            }
            else{
                result.error("type unsupported", "type invalid", "File type has to be given")
            }
        }
        if(call.method == "getFolderFile"){
            var folder = call.argument<String>("folder")
            if(folder != null) {
                if(folder.isEmpty()){
                    folder = MediaStore.VOLUME_EXTERNAL;
                }
                getFolderFile(result, folder)
            }
            else{
                result.error("Invaild folder", "Folder is empty", "Empty folder")
            }
        }
    }
  }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 2296) {
            if (SDK_INT >= Build.VERSION_CODES.R) {
                if (Environment.isExternalStorageManager()) {
                    // perform action when allow permission success
                } else {
                    Toast.makeText(this, "Allow permission for storage access!", Toast.LENGTH_SHORT)
                        .show()
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        when (requestCode) {
            2296 -> if (grantResults.isNotEmpty()) {
                val readLocalStoragePermission = grantResults[0] == PackageManager.PERMISSION_GRANTED
                if (!readLocalStoragePermission) {
                    Toast.makeText(this, "Allow permission for storage access!", Toast.LENGTH_SHORT)
                        .show()
                }
            }
        }

        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private fun checkPermission(): Boolean {
        return if (SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else {
            val result =
                ContextCompat.checkSelfPermission(this, READ_EXTERNAL_STORAGE)

            result == PackageManager.PERMISSION_GRANTED
        }
    }

     private fun requestPermission() {
        if (SDK_INT >= Build.VERSION_CODES.R) {
            try {
                val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
                intent.addCategory("android.intent.category.DEFAULT")
                intent.data =
                    Uri.parse(String.format("package:%s", applicationContext.packageName))
                startActivityForResult(intent, 2296)
            } catch (e: Exception) {
                val intent = Intent()
                intent.action = Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION
                startActivityForResult(intent, 2296)
            }
        } else {
            //below android 11
            ActivityCompat.requestPermissions(
                this,
                arrayOf(READ_EXTERNAL_STORAGE),
                2296
            )
        }
    }

    private fun runSearch(result: MethodChannel.Result, projection: Array<String>, externalUri:Uri, successCallback: (filesData: MutableList<Map<String, String>>) -> Unit, failureCallback: (reason: String)->Unit) {
        try {
            val fileData: MutableList<Map<String, String>> = mutableListOf()

            val permission = checkPermission()

            if (!permission) {
                requestPermission()
                failureCallback("Permission denied")
                // TODO: Handle this in the permission callback func
                result.success(fileData)
            }

            val selection = ""
            val selectionArgs = arrayOf<String>()
            val sortOrder = "${projection[4]} DESC"
            var projectionToQuery = projection.copyOf()

            projectionToQuery = projectionToQuery.filter { it.isNotEmpty() }.toTypedArray()
            applicationContext.contentResolver.query(
                externalUri,
                projectionToQuery,
                selection,
                selectionArgs,
                sortOrder
            )?.use { cursor ->
                val idColumn = cursor.getColumnIndexOrThrow(projection[0])
                val nameColumn =
                    cursor.getColumnIndexOrThrow(projection[1])
                val durationColumn =
                    if(projection[2].isEmpty()) null else cursor.getColumnIndexOrThrow(projection[2])
                val sizeColumn = cursor.getColumnIndexOrThrow(projection[3])

                while (cursor.moveToNext()) {
                    // Get values of columns for a given video.
                    val id = cursor.getLong(idColumn)
                    val name = cursor.getString(nameColumn)
                    val duration = if(durationColumn == null) null else cursor.getInt(durationColumn)
                    val size = cursor.getInt(sizeColumn)
                    val contentUri: Uri = ContentUris.withAppendedId(
                        externalUri,
                        id
                    )

                    fileData.add(mapOf("name" to name, "uri" to contentUri.toString(), "duration" to duration.toString(), "size" to size.toString(), "id" to id.toString()))
                }

                successCallback(fileData)
                result.success(fileData)
            }
        }
        catch (exp: Exception){
            failureCallback(exp.localizedMessage)
            result.success(mutableListOf<Map<String, String>>())
        }
    }

    private fun getThumbnail(result: MethodChannel.Result, uri: String, id: Long) {
        try {
            val fileData: MutableList<Map<String, String>> = mutableListOf()

            val permission = checkPermission()

            if (!permission) {
                requestPermission()
                // TODO: Handle this in the permission callback func
                result.success(fileData)
            }

            val bitmap = if (SDK_INT >= Build.VERSION_CODES.Q) {
                applicationContext.contentResolver.loadThumbnail( Uri.parse(uri), Size(50, 50), null)
            } else {
                MediaStore.Images.Thumbnails.getThumbnail(applicationContext.contentResolver, id, MediaStore.Images.Thumbnails.MINI_KIND, null)
            }
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
            val image = stream.toByteArray()
            result.success(image)
        } catch (ex: Exception) {

        }
    }

    private fun getProjections(type: String): Array<String> {
        when(type.lowercase()){
            "video"->
                return videoProjection
            "image"->
                return imageProjection
            "audio"->
                return audioProjection
            "download" ->
                return downloadProjection
            "file" ->
                return fileProjections
        }

        return arrayOf()
    }

    private fun getExternalContentUri(type: String): Uri {
        when(type.lowercase()){
            "video"->
                return MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            "image"->
                return MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            "audio"->
                return MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            "download" ->
                return if (SDK_INT >= Build.VERSION_CODES.Q) {
                    MediaStore.Downloads.EXTERNAL_CONTENT_URI
                } else {
                    TODO("VERSION.SDK_INT < Q")
                    Uri.EMPTY
                }
            "file" ->
                    return MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL)
        }

        return MediaStore.Files.getContentUri(MediaStore.VOLUME_EXTERNAL)
    }

    private fun getFolderFile(result: MethodChannel.Result, folderName: String) {
        val fileData: MutableList<Map<String, String>> = mutableListOf()
        val projection = getProjections("file")
        val externalUri = getExternalContentUri("file")
        applicationContext.contentResolver.query(
            getExternalContentUri("file"),
            getProjections("file"),
            "${MediaStore.Files.FileColumns.PARENT} like?",
            arrayOf(folderName),
            null,
        )?.use { cursor ->
            val idColumn = cursor.getColumnIndexOrThrow(projection[0])
            val nameColumn =
                cursor.getColumnIndexOrThrow(projection[1])
            val durationColumn =
                if(projection[2].isEmpty()) null else cursor.getColumnIndexOrThrow(projection[2])
            val sizeColumn = cursor.getColumnIndexOrThrow(projection[3])

            while (cursor.moveToNext()) {
                // Get values of columns for a given video.
                val id = cursor.getLong(idColumn)
                val name = cursor.getString(nameColumn)
                val duration = if(durationColumn == null) null else cursor.getInt(durationColumn)
                val size = cursor.getInt(sizeColumn)
                val contentUri: Uri = ContentUris.withAppendedId(
                    externalUri,
                    id
                )

                fileData.add(mapOf("name" to name, "uri" to contentUri.toString(), "duration" to duration.toString(), "size" to size.toString(), "id" to id.toString()))
            }

            result.success(fileData)
        }
    }
}
