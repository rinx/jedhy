(require [src.utils.macros [*]])
(import [src.utils.macros [*]])
(require [hy.extra.anaphoric [*]])

(defn -translate-class [klass]
  "Return annotation given a name of a class."
  (cond [(in klass ["function" "builtin_function_or_method"])
         "def"]
        [(= klass "type")
         "class"]
        [(= klass "module")
         "module"]
        [True
         "instance"]))

(defn annotate [candidate]
  "Return annotation for a candidate."
  (setv obj
        (.evaled? candidate))

  (setv annotation
        (cond [(not (none? obj))  ; Obj could be instance of bool
               (-translate-class obj.--class--.--name--)]
              ;; Shadow takes priority over compiler annotations
              [(.shadow? candidate)
               "shadowed"]
              [(.compiler? candidate)
               "compiler"]
              [(.macro? candidate)
               "macro"]))

  (.format "<{} {}>" annotation candidate.symbol))