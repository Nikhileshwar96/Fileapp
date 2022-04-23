package com.example.file_app

import android.Manifest.permission.READ_EXTERNAL_STORAGE
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Build.VERSION.SDK_INT
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CompletableDeferred

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "samples.flutter.dev/battery"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
       call, result ->
      if (call.method == "getFiles") {
          val successCB :(MutableList<Map<String, String>>)-> Unit ={
              fileDatas ->
          }
          val failureCB :(String)-> Unit ={
                  reason ->
          }

          runSearch(result, successCB, failureCB);

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
            2296 -> if (grantResults.size > 0) {
                val READ_EXTERNAL_STORAGE = grantResults[0] == PackageManager.PERMISSION_GRANTED
                if (!READ_EXTERNAL_STORAGE) {
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

    private fun runSearch(result: MethodChannel.Result ,successCallback: (filesDatas: MutableList<Map<String, String>>) -> Unit, failureCallback: (reason: String)->Unit) {
        try {
            val fileDatas: MutableList<Map<String, String>> = mutableListOf();

            val permission = checkPermission();

            if (!permission) {
                requestPermission();
                failureCallback("Permission denied");
                result.success(fileDatas)
            }

            val projection = arrayOf(
                MediaStore.Video.Media.DISPLAY_NAME,
                MediaStore.Video.Media._ID,
                MediaStore.Video.Media.DURATION,
                MediaStore.Video.Media.SIZE
            )
            val selection = ""
            val selectionArgs = arrayOf<String>()
            val sortOrder = "${MediaStore.Video.Media.DATE_TAKEN} DESC"
            applicationContext.contentResolver.query(
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                projection,
                selection,
                selectionArgs,
                sortOrder
            )?.use { cursor ->
                val nameColumn =
                    cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DISPLAY_NAME)
                val pathColumn =
                    cursor.getColumnIndexOrThrow(MediaStore.Video.Media._ID)
                val durationColumn =
                    cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DURATION)
                val sizeColumn = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.SIZE)
                while (cursor.moveToNext()) {
                    // Get values of columns for a given video.
                    val name = cursor.getString(nameColumn)
                    val duration = cursor.getInt(durationColumn)
                    val size = cursor.getInt(sizeColumn)
                    val path = cursor.getString(pathColumn)

                    fileDatas.add(mapOf("name" to name, "uri" to path))
                }

                successCallback(fileDatas);
                result.success(fileDatas)
            }
        }
        catch (exp: Exception){
            failureCallback(exp.localizedMessage)
            result.success(mutableListOf<Map<String, String>>())
        }
    }
}
