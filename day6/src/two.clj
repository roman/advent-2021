(ns two
  (:require [clojure.string :as str]))

(defn laternfish-count [f n i]
  (let [total (- n (+ i 1))]
    (if (< total 0)
      1
      ;; else
      (+ (f f total 6)
         (f f total 8)))))

(defn run [_]
  (let [laternfish-count-m (memoize laternfish-count)
        numbers (map #(Integer/parseInt %)
                     (str/split (str/trim (slurp *in*)) #","))]
    (println (apply + (map #(laternfish-count-m laternfish-count-m 256 %) numbers)))))
