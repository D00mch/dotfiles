import com.intellij.openapi.actionSystem.CommonDataKeys
import liveplugin.registerAction
import liveplugin.show
import kotlin.math.max
import kotlin.math.min

show("Current project: ${project?.name}")

registerAction("SelectInForm", function = { event ->
    val project = event.project
    val editor = CommonDataKeys.EDITOR.getData(event.dataContext)
    if (project == null || editor == null) return@registerAction

    val actionManager = com.intellij.openapi.actionSystem.ActionManager.getInstance()
    val actionEditorMatchBrace = actionManager.getAction("EditorMatchBrace")
    actionEditorMatchBrace.actionPerformed(event)
    val formStart = editor.caretModel.offset
    actionEditorMatchBrace.actionPerformed(event)
    val formEnd = editor.caretModel.offset
    val i = min(formStart, formEnd)
    val j = max(formStart, formEnd)
    editor.selectionModel.setSelection(i + 1, j - 1)
    editor.caretModel.moveToOffset(j - 1)
})
if (!isIdeStartup) show("Loaded 'SelectInForm'")
