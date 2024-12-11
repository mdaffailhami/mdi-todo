package com.mdi.mdi_todo

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import HomeWidgetGlanceWidgetReceiver
import android.content.Context
import android.net.Uri
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
import androidx.glance.appwidget.cornerRadius
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
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.actionStartActivity
import androidx.glance.color.ColorProvider as DayNightColorProvider

data class ActiveTask(val id: String, val title: String, val deadline: String)

fun getThemeBasedColor(themeMode: String?, light: Color, dark: Color) : ColorProvider {
    return when (themeMode) {
        "light" -> ColorProvider(light)
        "dark" -> ColorProvider(dark)
        else -> DayNightColorProvider(day = light, night = dark)
    }
}

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
        val themeMode = prefs.getString("theme_mode", null)
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

        val darkColor = Color(0xFF111318)

        Column {
            Row(
                modifier = GlanceModifier.clickable(
                    onClick = actionStartActivity<MainActivity>(context)
                ).background(getThemeBasedColor(themeMode, Color.White, darkColor))
                .fillMaxWidth()
                .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Image(
                    provider = ImageProvider(R.drawable.launch_background),
                    contentDescription = "MDI Todo",
                    modifier = GlanceModifier.size(36.dp).cornerRadius(12.dp)
                )
                Spacer(modifier = GlanceModifier.width(10.dp))
                Text(
                    text = "Active Tasks",
                    style = TextStyle(
                        fontSize = 19.sp,
                        fontWeight = FontWeight.Bold,
                        color = getThemeBasedColor(themeMode, Color(0xFF00579e), Color(0xFFa4c9fe))
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
                    .background(getThemeBasedColor(themeMode, Color.White, darkColor))
                    .padding(horizontal = 6.dp)
            ) {

                if (activeTasks.isEmpty()) {
                    // If tasks are empty, show a message
                    Column (
                        modifier = GlanceModifier.
                        fillMaxSize().
                        background(getThemeBasedColor(themeMode, Color.White, darkColor)),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "No active tasks",
                            style = TextStyle(
                                fontSize = 17.sp,
                                color = getThemeBasedColor(themeMode, Color.Black, Color.White)
                            ),
                            modifier = GlanceModifier.wrapContentSize()
                        )
                    }
                }else{
                    LazyColumn(
                        modifier = GlanceModifier.padding(10.dp)
                    ) {
                        items(activeTasks) { activeTask ->
                            Column(
                                // Open task when clicked
                                modifier = GlanceModifier.clickable(
                                    onClick = actionStartActivity<MainActivity>(
                                        context,
                                        Uri.parse("homewidget://com.mdi.mdi_todo/open-task/${activeTask.id}")
                                    )
                                ).fillMaxWidth().background(getThemeBasedColor(themeMode, Color.White, darkColor))
                            ) {
                                Text(
                                    text = activeTask.title,
                                    maxLines = 1,
                                    style = TextStyle(
                                        fontSize = 17.sp,
                                        color = getThemeBasedColor(themeMode, Color.Black, Color.White)
                                    )
                                )
                                Text(
                                    text = activeTask.deadline,
                                    maxLines = 1,
                                    style = TextStyle(
                                        fontSize = 15.sp,
                                        color = ColorProvider(Color.Gray)
                                    )
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
