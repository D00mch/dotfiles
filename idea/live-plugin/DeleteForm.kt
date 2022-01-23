import com.intellij.openapi.actionSystem.CommonDataKeys
import liveplugin.executeCommand
import liveplugin.registerAction
import liveplugin.show

show("Current project: ${project?.name}")

registerAction("DeleteForm", function = { event ->
    val project = event.project
    val editor = CommonDataKeys.EDITOR.getData(event.dataContext)
    if (project == null || editor == null) return@registerAction

    val actionManager = com.intellij.openapi.actionSystem.ActionManager.getInstance()
    val actionEditorMatchBrace = actionManager.getAction("EditorMatchBrace")
    actionEditorMatchBrace.actionPerformed(event)
    val formStart = editor.caretModel.offset
    actionEditorMatchBrace.actionPerformed(event)
    val formEnd = editor.caretModel.offset

    editor.selectionModel.setSelection(formStart, formEnd)
    editor.document.executeCommand(project, "DeleteForm")  { deleteString(formStart, formEnd) }
})
if (!isIdeStartup) show("Loaded 'DeleteForm'")
