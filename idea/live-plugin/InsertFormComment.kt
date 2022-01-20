import com.intellij.openapi.actionSystem.CommonDataKeys
import com.intellij.openapi.editor.Document
import liveplugin.executeCommand
import liveplugin.registerAction
import liveplugin.show
import kotlin.math.max

show("Current project: ${project?.name}")

registerAction("insertClojureCommentAtTheFormStart", function = { event ->
    val project = event.project
    val editor = CommonDataKeys.EDITOR.getData(event.dataContext)
    if (project == null || editor == null) return@registerAction

    val actionManager = com.intellij.openapi.actionSystem.ActionManager.getInstance()
    val document = editor.document
    val caretIndex = editor.caretModel.offset
    val currentChar = document.text[caretIndex]

    val startFormChars = charArrayOf('"', '(', '{', '[')

    if (currentChar.isLetterOrDigit() && isPreviousEmpty(document, caretIndex)) { //beginning of a word
        /* just insert here */
    } else if (startFormChars.contains(currentChar)) {
        /* just insert here */
    } else {
        val actionEditorMatchBrace = actionManager.getAction(":cursive.actions.paredit/backward-up")
        actionEditorMatchBrace.actionPerformed(event)
    }
    document.executeCommand(project, "insertClojureCommentAtTheFormStart") {
        document.insertString(editor.caretModel.offset, "#_")
    }
})

fun isPreviousEmpty(document: Document, caretIndex: Int) =
        document.text[max(caretIndex - 1, 0)] == ' '
