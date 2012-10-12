(require 'ert)
(require 'jira-markup-mode)

(defun with-leading-whitespace (str)
  (concat "  " str))

(defun should-match-trimmed (regex str)
  (should (string-match regex str))
  (should (string= (chomp str) (match-string 0 str))))

(defun chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (while (string-match "^\\s-" str)
    (setq str (replace-match "" t t str)))
  (while (string-match "\\s-$" str)
    (setq str (replace-match "" t t str)))
  str)

(ert-deftest chomp-test ()
  (let ((expected "foo"))
    (should (string= expected (chomp " foo")))
    (should (string= expected (chomp "   foo")))
    (should (string= expected (chomp "foo ")))
    (should (string= expected (chomp "   foo    ")))))

;; regex
(ert-deftest jira-markup-regex-header-1-test ()
  (should (string-match-p jira-markup-regex-header-1 "h1. "))
  (should (string-match-p jira-markup-regex-header-1 "h1. Header"))
  (should (string-match-p jira-markup-regex-header-1 "   h1.    Header   "))
  (should-not (string-match-p jira-markup-regex-header-1 "a h1. Header"))
  (should-not (string-match-p jira-markup-regex-header-1 " a h1. Header")))

(ert-deftest jira-markup-regex-header-2-test ()
  (should (string-match-p jira-markup-regex-header-2 "h2. "))
  (should (string-match-p jira-markup-regex-header-2 "h2. Header"))
  (should-not (string-match-p jira-markup-regex-header-2 "a h2. Header"))
  (should-not (string-match-p jira-markup-regex-header-2 " a h2. Header")))

(ert-deftest jira-markup-regex-header-3-test ()
  (should (string-match-p jira-markup-regex-header-3 "h3. "))
  (should (string-match-p jira-markup-regex-header-3 "h3. Header"))
  (should-not (string-match-p jira-markup-regex-header-3 "a h3. Header"))
  (should-not (string-match-p jira-markup-regex-header-3 " a h3. Header")))

(ert-deftest jira-markup-regex-header-4-test ()
  (should (string-match-p jira-markup-regex-header-4 "h4. "))
  (should (string-match-p jira-markup-regex-header-4 "h4. Header"))
  (should-not (string-match-p jira-markup-regex-header-4 "a h4. Header"))
  (should-not (string-match-p jira-markup-regex-header-4 " a h4. Header")))

(ert-deftest jira-markup-regex-header-5-test ()
  (should (string-match-p jira-markup-regex-header-5 "h5. "))
  (should (string-match-p jira-markup-regex-header-5 "h5. Header"))
  (should-not (string-match-p jira-markup-regex-header-5 "a h5. Header"))
  (should-not (string-match-p jira-markup-regex-header-5 " a h5. Header")))

(ert-deftest jira-markup-regex-header-6-test ()
  (should (string-match-p jira-markup-regex-header-6 "h6. "))
  (should (string-match-p jira-markup-regex-header-6 "h6. Header"))
  (should-not (string-match-p jira-markup-regex-header-6 "a h6. Header"))
  (should-not (string-match-p jira-markup-regex-header-6 " a h6. Header")))

(ert-deftest jira-markup-regex-strong-test ()
  (should (string-match-p jira-markup-regex-strong " *strong* "))
  (should (string-match-p jira-markup-regex-strong " *str*ng* "))
  (should-not (string-match-p jira-markup-regex-strong "*strong*")))

(ert-deftest jira-markup-regex-emphasis-test ()
  (should (string-match-p jira-markup-regex-emphasis " _emphasis_ "))
  (should (string-match-p jira-markup-regex-emphasis " _emph_sis_ "))
  (should-not (string-match-p jira-markup-regex-emphasis "_emphasis_")))

(ert-deftest jira-markup-regex-citation-test ()
  (should (string-match-p jira-markup-regex-citation " ??citation?? "))
  (should (string-match-p jira-markup-regex-citation " ??cit??tion?? "))
  (should-not (string-match-p jira-markup-regex-citation "??citation??")))

(ert-deftest jira-markup-regex-deleted-test ()
  (should (string-match-p jira-markup-regex-deleted " -deleted- "))
  (should (string-match-p jira-markup-regex-deleted " -dele-ted- "))
  (should-not (string-match-p jira-markup-regex-deleted "--deleted--"))
  (should-not (string-match-p jira-markup-regex-deleted "-deleted-")))

(ert-deftest jira-markup-regex-inserted-text ()
  (should (string-match-p jira-markup-regex-inserted " +inserted+ "))
  (should (string-match-p jira-markup-regex-inserted " +inser+ed+ "))
  (should-not (string-match-p jira-markup-regex-inserted "+inserted+")))

(ert-deftest jira-markup-regex-superscript-text()
  (should (string-match-p jira-markup-regex-superscript " ^superscript^ "))
  (should (string-match-p jira-markup-regex-superscript " ^super^script^ "))
  (should-not (string-match-p jira-markup-regex-superscript "^superscript^")))

(ert-deftest jira-markup-regex-subscript-text ()
  (should (string-match-p jira-markup-regex-subscript " ~subscript~ "))
  (should (string-match-p jira-markup-regex-subscript " ~subs~cript~ "))
  (should-not (string-match-p jira-markup-regex-subscript "~subscript~")))

(ert-deftest jira-markup-regex-monospaced-text ()
  (should (string-match jira-markup-regex-monospaced " {{monospaced}} "))
  (should (string= " {{monospaced}} " (match-string 0 " {{monospaced}} ")))
  (should (string-match jira-markup-regex-monospaced " {{mono{{}}spaced}} "))
  (should (string= " {{mono{{}}spaced}} " (match-string 0 " {{mono{{}}spaced}} ")))
  (should-not (string-match-p jira-markup-regex-monospaced "{{monospaced}}")))

(ert-deftest jira-markup-regex-blockquote-test ()
  (should (string-match-p jira-markup-regex-blockquote "bq. "))
  (should (string-match-p jira-markup-regex-blockquote "  bq.  "))
  (should (string-match-p jira-markup-regex-blockquote "bq. the-quote"))
  (should (string-match-p jira-markup-regex-blockquote "  bq.   the-quote  "))
  (should-not (string-match-p jira-markup-regex-blockquote "a bq. the-quote")))

(ert-deftest jira-markup-regex-hr-test ()
  (should (string-match-p jira-markup-regex-hr "----"))
  (should (string-match-p jira-markup-regex-hr (with-leading-whitespace "----")))
  (should-not (string-match-p jira-markup-regex-hr "---"))
  (should-not (string-match-p jira-markup-regex-hr "-----")))
