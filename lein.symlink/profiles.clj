{:user {:signing {:gpg-key  "BCD30C6B06AB054965ABE939D9A9047993B32AD6"}
        :plugins [[refactor-nrepl "2.5.0"]
                  [cider/cider-nrepl "0.25.0-alpha1"]
                  [lein-ancient "0.6.15"]
                  [venantius/yagni "0.1.7"]]
        :dependencies [[nrepl "0.7.0"]]
        :repl-options {:nrepl-middleware [refactor-nrepl.middleware/wrap-refactor]}}}}

