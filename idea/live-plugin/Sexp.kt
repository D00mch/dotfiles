import liveplugin.show

// set it up with live plugin
// https://plugins.jetbrains.com/plugin/7282-liveplugin
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.actionSystem.CommonDataKeys
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.editor.Document
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.project.Project
import liveplugin.*
import kotlin.math.max
import kotlin.math.min

show("Current project: ${project?.name}")

fun Document.executeCommand(project: Project, name: String, call: Document.() -> Unit) {
    ApplicationManager.getApplication().runWriteAction {
        CommandProcessor.getInstance().executeCommand(
            project,
            { call() },
            name,
            com.intellij.openapi.command.UndoConfirmationPolicy.DEFAULT,
            this
        )
    }
}

registerAction("DeleteAForm", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i, j)
    editor.selectionModel.copySelectionToClipboard()
    editor.document.executeCommand(project, "DeleteAForm") { deleteString(i, j) }
    editor.caretModel.moveToOffset(i - 1)
})

registerAction("DeleteInForm", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i + 1, j - 1)
    editor.selectionModel.copySelectionToClipboard()
    editor.document.executeCommand(project, "DeleteInForm") { deleteString(i + 1, j - 1) }
    editor.caretModel.moveToOffset(i)
})

registerAction("ChangeAForm", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i, j)
    editor.selectionModel.copySelectionToClipboard()
    editor.document.executeCommand(project, "ChangeAForm") { deleteString(i, j) }
})

registerAction("ChangeInForm", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i + 1, j - 1)
    editor.selectionModel.copySelectionToClipboard()
    editor.document.executeCommand(project, "ChangeInForm") { deleteString(i + 1, j - 1) }
    editor.caretModel.moveToOffset(i + 1)
})

registerAction("SelectAForm", function = { event ->
    val (_, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i, j)
})

registerAction("SelectInForm", function = { event ->
    val (_, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i + 1, j - 1)
    editor.caretModel.moveToOffset(j - 1)
})

registerAction("YankAForm", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i, j)
    editor.selectionModel.copySelectionToClipboard()
    editor.selectionModel.removeSelection()
})

registerAction("YankInForm", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val (i, j) = getFormIndexes(event, editor)
    editor.selectionModel.setSelection(i + 1, j - 1)
    editor.selectionModel.copySelectionToClipboard()
    editor.caretModel.moveToOffset(j - 1)
    editor.selectionModel.removeSelection()
})

registerAction("InsertClojureCommentAtTheFormStart", function = { event ->
    val (project, editor) = prepareOrNull(event) ?: return@registerAction
    val actionManager = com.intellij.openapi.actionSystem.ActionManager.getInstance()
    val document = editor.document
    val caretIndex = editor.caretModel.offset
    val currentChar = document.text[caretIndex]

    val startFormChars = charArrayOf('"', '(', '{', '[')

    if (currentChar.isLetterOrDigit() && isPreviousEmpty(document, caretIndex)) { //beginning of a word
        /* just insert here */
    } else if (startFormChars.contains(currentChar)) { // already at the form char
        /* just insert here */
    } else {
        val (i, j) = getFormIndexes(event, editor)
        editor.caretModel.moveToOffset(i)
    }
    document.executeCommand(project, "insertClojureCommentAtTheFormStart") {
        insertString(editor.caretModel.offset, "#_")
    }
})

/** returns start and end index of a form */
fun getFormIndexes(event: AnActionEvent, editor: Editor): Pair<Int, Int> {
    val actionManager = com.intellij.openapi.actionSystem.ActionManager.getInstance()
    val actionEditorMatchBrace = actionManager.getAction("EditorMatchBrace")
    actionEditorMatchBrace.actionPerformed(event)
    val formStart = editor.caretModel.offset
    actionEditorMatchBrace.actionPerformed(event)
    val formEnd = editor.caretModel.offset
    val i = min(formStart, formEnd)
    val j = max(formStart, formEnd)
    return i to j
}

fun isPreviousEmpty(document: Document, caretIndex: Int) =
    document.text[max(caretIndex - 1, 0)] == ' '

fun prepareOrNull(event: AnActionEvent): Pair<Project, Editor>? {
    val project = event.project
    val editor = CommonDataKeys.EDITOR.getData(event.dataContext)
    return if (project == null || editor == null) null else Pair(project, editor)
}
