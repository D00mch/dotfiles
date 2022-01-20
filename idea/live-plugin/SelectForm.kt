import com.intellij.openapi.actionSystem.CommonDataKeys
import liveplugin.registerAction
import liveplugin.show

show("Current project: ${project?.name}")

registerAction("SelectForm", "ctrl alt shift W", function = { event ->

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
})
if (!isIdeStartup) show("Loaded 'insertClojureComment' action<br/>Use 'Ctrl+Alt+Shift+W' to run it")
