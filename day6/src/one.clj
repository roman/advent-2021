(ns one
  (:require [clojure.string :as str]))

(defn laternfish-count [n i]
  (let [total (- n (+ i 1))]
    (if (< total 0)
      1
      ;; else
      (+ (laternfish-count total 6)
         (laternfish-count total 8)))))

(defn run [_]
  (let [numbers (map #(Integer/parseInt %)
                     (str/split (str/trim (slurp *in*)) #","))]
    (println (apply + (map #(laternfish-count 80 %) numbers)))))
