(local has-key (os.getenv :OPENAI_API_KEY))

(fn map-key-bindings []
  (let [wk (require :which-key)
        {: kset} (require :config.util)]

    (wk.add {1 :<space>c :group :gpt})

    (kset :n :<space>cf ":GpChatFinder<cr>" "Finder")
    (kset :n :<space>cr ":GpChatRespond<cr>" "Respond")
    (kset :n :<space>cs ":GpStop<cr>" "Stop")
    (kset :n :<space>cb ":GpChatBackend<cr>" "Backend")
    (kset :n :<space>cg ":GpChatGrammar<cr>" "Grammar")
    (kset :n :<space>ci ":GpChatIT<cr>" "IT")
    (kset :n :<space>ct ":GpChatTranslator<cr>" "Translator")))

(local gp-hooks 
  {:ChatTranslator
   (fn [gp params]
     (let [chat-system-prompt "You are a Translator, translate between English and Russian"]
       (gp.cmd.ChatNew params chat-system-prompt)))

   :ChatBackend
   (fn [gp params]
     (let [chat-system-prompt (os.getenv :BACKEND_PROMPT)]
       (gp.cmd.ChatNew params chat-system-prompt)))

   :ChatGrammar
   (fn [gp params]
     (let [chat-system-prompt (os.getenv :GRAMMAR_PROMPT)]
       (gp.cmd.ChatNew params chat-system-prompt)))

   :ChatIT
   (fn [gp params]
     (let [chat-system-prompt (os.getenv :IT_PROMPT)]
       (gp.cmd.ChatNew params chat-system-prompt)))})

[{1 :Robitx/gp.nvim
  :lazy true
  :event :VeryLazy
  :cond has-key
  :config  #(let [gp (require :gp)
                  defaults (require :gp.defaults)]

              (map-key-bindings)

              (gp.setup 
                {:chat_shortcut_respond {:modes [:n]
                                         :shortcut :<leader>b}
                 :chat_shortcut_stop {:modes [:n]
                                      :shortcut :<leader>x}

                 :hooks gp-hooks

                 :image
                 {:prompt_save "🖌️💾 ~ "
                  :store_dir (.. (os.getenv "HOME") "/Downloads/")}

                 :agents
                 [{:name "gpt-4o"
                   :chat true
                   :model {:model "gpt-4o"
                           :temperature 1.1
                           :top_p 1}
                   :system_prompt (. defaults :chat_system_prompt)}]}))}]
