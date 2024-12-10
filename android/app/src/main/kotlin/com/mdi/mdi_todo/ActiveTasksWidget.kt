package com.mdi.mdi_todo

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import HomeWidgetGlanceWidgetReceiver
import android.content.Context
import android.provider.CalendarContract.Colors
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.lazy.items
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.layout.wrapContentSize
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.preview.Preview
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.actionStartActivity

data class ActiveTask(val title: String, val deadline: String)

class ActiveTasksWidgetReceiver : HomeWidgetGlanceWidgetReceiver<ActiveTasksWidget>() {
    override val glanceAppWidget = ActiveTasksWidget()
}

class ActiveTasksWidget : GlanceAppWidget() {
    override val stateDefinition: GlanceStateDefinition<*>
        get() = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val prefs = currentState.preferences
        val jsonString = prefs.getString("active_tasks", "[]")

//        Dummy data
//        val jsonString = """
//            [
//              {
//                "title": "Buy groceries",
//                "deadline": "Tuesday, December 10"
//              },
//              {
//                "title": "Walk the dog",
//                "deadline": "Wednesday, December 11"
//              },
//              {
//                "title": "Finish project",
//                "deadline": "Thursday, December 12"
//              }
//            ]
//        """.trimIndent()

        val gson = Gson()
        val listType = object : TypeToken<List<ActiveTask>>() {}.type

        val activeTasks: List<ActiveTask> = gson.fromJson(jsonString, listType)

        Column{
            Row(
                modifier = GlanceModifier.clickable(
                    onClick = actionStartActivity<MainActivity>(context)
                )
                .background(Color.White)
                .fillMaxWidth()
                .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Image(
                    provider = ImageProvider(R.drawable.ic_launcher_foreground),
                    contentDescription = "MDI Todo",
                    modifier = GlanceModifier.size(36.dp)
                )
                Spacer(modifier = GlanceModifier.width(8.dp))
                Text(
                    text = "Active Tasks",
                    style = TextStyle(
                        fontSize = 19.sp,
                        fontWeight = FontWeight.Bold,
                        color = ColorProvider(Color(0xFF00579e))
                    ),
                )
            }
            // Divider
            Box(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .height(0.5.dp)
                    .background(Color.Gray)
            ){}
            // /Divider
            Box(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .background(Color.White)
                    .padding(start = 6.dp, end = 6.dp, bottom = 6.dp)
            ) {

                if (activeTasks.isEmpty()) {
                    // If tasks are empty, show a message
                    Column (
                        modifier = GlanceModifier.fillMaxSize().background(Color.White),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "No active tasks",
                            style = TextStyle(fontSize = 17.sp),
                            modifier = GlanceModifier.wrapContentSize()
                        )
                    }
                }else{
                    LazyColumn(
                        modifier = GlanceModifier
                            .background(Color.White)
                            .padding(10.dp)
                    ) {
                        items(activeTasks) { activeTask ->
                            Column {
                                Text(
                                    text = activeTask.title,
                                    maxLines = 1,
                                    style = TextStyle(fontSize = 17.sp)
                                )
                                Text(
                                    text = activeTask.deadline,
                                    maxLines = 1,
                                    style = TextStyle(fontSize = 15.sp, color = ColorProvider(Color.Gray))
                                )
                                Spacer(modifier = GlanceModifier.height(10.dp))
                            }
                        }
                    }
                }
            }
        }
    }
}

//Column(
//modifier = GlanceModifier
//.padding(16.dp)
////                .clickable { onTap?.invoke() }
//) {
//    for (taskTitle in taskTitles) {
//        Text(
//            text = taskTitle,
////                style = MaterialTheme.typography.titleMedium,
//            maxLines = 1
//        )
//    }
////            Text(
////                text = formatDate(task.deadline),
////                style = MaterialTheme.typography.bodyMedium
////            )
//}
//
//
////        fun formatDate(date: Date): String {
////            val format = SimpleDateFormat("yyyy-MM-dd")
////            return format.format(date)
////        }