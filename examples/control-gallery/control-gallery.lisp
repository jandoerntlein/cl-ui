(in-package #:control-gallery)

(defvar *mainwin* nil)

(defun menu-open-clicked (window)
  (declare (ignore window))
  (let ((filename (cl-ui.raw:open-file (cl-ui::object-pointer *mainwin*))))
    (if (null filename)
        (cl-ui.raw:msg-box-error (cl-ui::object-pointer *mainwin*) "No file selected" "Don't be alarmed!")
        (cl-ui.raw:msg-box (cl-ui::object-pointer *mainwin*) "File selected" filename))))

(defun menu-save-clicked (window)
  (declare (ignore window))
  (let ((filename (cl-ui.raw:save-file (cl-ui::object-pointer *mainwin*))))
    (if (null filename)
        (cl-ui.raw:msg-box-error (cl-ui::object-pointer *mainwin*) "No file selected" "Don't be alarmed!")
        (cl-ui.raw:msg-box (cl-ui::object-pointer *mainwin*) "File selected (don't worry, it's still there)"
                           filename))))

(defun %main ()
  (let ((menu (make-instance 'cl-ui:menu :name "File")))
    (setf (cl-ui:menu-item-on-clicked (cl-ui:menu-append-item menu "Open")) #'menu-open-clicked
          (cl-ui:menu-item-on-clicked (cl-ui:menu-append-item menu "Save")) #'menu-save-clicked)
    (cl-ui:menu-append-quit-item menu)
    (setf (cl-ui:on-should-quit) (lambda ()
                                   (cl-ui:control-destroy *mainwin*)
                                   (setf *mainwin* nil)
                                   t)))
  (let ((menu (make-instance 'cl-ui:menu :name "Edit")))
    (cl-ui:menu-append-check-item menu "Checkable Item")
    (cl-ui:menu-append-separator menu)
    (setf (cl-ui:menu-item-enabled-p (cl-ui:menu-append-item menu "Disabled Item")) nil)
    (cl-ui:menu-append-preferences-item menu))
  (let ((menu (make-instance 'cl-ui:menu :name "Help")))
    (cl-ui:menu-append-item menu "Help")
    (cl-ui:menu-append-about-item menu))

  (setf *mainwin* (make-instance 'cl-ui:window :title "libui Control Gallery"
                                               :width 640
                                               :height 480
                                               :has-menu-bar t))
  (setf (cl-ui:window-margined *mainwin*)   t
        (cl-ui:window-on-closing *mainwin*) (lambda ()
                                              (cl-ui:control-destroy *mainwin*)
                                              (setf *mainwin* nil)
                                              (cl-ui:quit)
                                              nil))

  (let ((box (make-instance 'cl-ui:box :direction :vertical))
        (hbox (make-instance 'cl-ui:box :direction :horizontal))
        (group (make-instance 'cl-ui:group :title "Basic Controls"))
        (inner (make-instance 'cl-ui:box :direction :vertical))
        (entry (make-instance 'cl-ui:entry))
        (inner2 (make-instance 'cl-ui:box :direction :vertical))
        (group2 (make-instance 'cl-ui:group :title "Numbers"))
        (inner3 (make-instance 'cl-ui:box :direction :vertical))
        (spinbox (make-instance 'cl-ui:spinbox :min-value 0 :max-value 100))
        (slider (make-instance 'cl-ui:slider :min-value 0 :max-value 100))
        (progress-bar (make-instance 'cl-ui:progress-bar))
        (group3 (make-instance 'cl-ui:group :title "Lists"))
        (inner4 (make-instance 'cl-ui:box :direction :vertical))
        (cbox (make-instance 'cl-ui:combobox))
        (ecbox (make-instance 'cl-ui:editable-combobox))
        (rb (make-instance 'cl-ui:radio-buttons))
        (tab (make-instance 'cl-ui:tab)))
    (setf (cl-ui:box-padded box)         t
          (cl-ui:window-child *mainwin*) box
          (cl-ui:box-padded hbox)        t)
    (cl-ui:box-append box hbox :stretchy t)

    (setf (cl-ui:group-margined group) t)
    (cl-ui:box-append hbox group)

    (setf (cl-ui:box-padded inner)  t
          (cl-ui:group-child group) inner)

    (cl-ui:box-append inner (make-instance 'cl-ui:button :text "Button"))
    (cl-ui:box-append inner (make-instance 'cl-ui:checkbox :text "Checkbox"))
    (setf (cl-ui:entry-text entry) "Entry")
    (cl-ui:box-append inner entry)
    (cl-ui:box-append inner (make-instance 'cl-ui:label :text "Label"))

    (cl-ui:box-append inner (make-instance 'cl-ui:separator))

    (cl-ui:box-append inner (make-instance 'cl-ui:date-time-picker :type :date))
    (cl-ui:box-append inner (make-instance 'cl-ui:date-time-picker :type :time))
    (cl-ui:box-append inner (make-instance 'cl-ui:date-time-picker :type :both))

    (cl-ui.raw:box-append (cl-ui::object-pointer inner) (cl-ui.raw:new-font-button) nil)

    (cl-ui.raw:box-append (cl-ui::object-pointer inner) (cl-ui.raw:new-color-button) nil)

    (setf (cl-ui:box-padded inner2) t)
    (cl-ui:box-append hbox inner2 :stretchy t)

    (setf (cl-ui:group-margined group2) t)
    (cl-ui:box-append inner2 group2)

    (setf (cl-ui:box-padded inner3)  t
          (cl-ui:group-child group2) inner3)

    (flet ((update (value)
             (setf (cl-ui:spinbox-value spinbox)           value
                   (cl-ui:slider-value slider)             value
                   (cl-ui:progress-bar-value progress-bar) value)))
      (setf (cl-ui:spinbox-on-changed spinbox)
            (lambda () (update (cl-ui:spinbox-value spinbox))))
      (cl-ui:box-append inner3 spinbox)
      (setf (cl-ui:slider-on-changed slider)
            (lambda () (update (cl-ui:slider-value slider))))
      (cl-ui:box-append inner3 slider)
      (cl-ui:box-append inner3 progress-bar))

    (setf (cl-ui:group-margined group3) t)
    (cl-ui:box-append inner2 group3)

    (setf (cl-ui:box-padded inner4) t
          (cl-ui:group-child group3) inner4)

    (cl-ui:combobox-append cbox "Combobox Item 1")
    (cl-ui:combobox-append cbox "Combobox Item 2")
    (cl-ui:combobox-append cbox "Combobox Item 3")
    (cl-ui:box-append inner4 cbox)

    (cl-ui:editable-combobox-append ecbox "Editable Item 1")
    (cl-ui:editable-combobox-append ecbox "Editable Item 2")
    (cl-ui:editable-combobox-append ecbox "Editable Item 3")
    (cl-ui:box-append inner4 ecbox)

    (cl-ui:radio-buttons-append rb "Radio Button 1")
    (cl-ui:radio-buttons-append rb "Radio Button 2")
    (cl-ui:radio-buttons-append rb "Radio Button 3")
    (cl-ui:box-append inner4 rb :stretchy t)

    (cl-ui:tab-append tab "Page 1" (make-instance 'cl-ui:box :direction :horizontal))
    (cl-ui:tab-append tab "Page 2" (make-instance 'cl-ui:box :direction :horizontal))
    (cl-ui:tab-append tab "Page 3" (make-instance 'cl-ui:box :direction :horizontal))
    (cl-ui:box-append inner2 tab :stretchy t))

  (setf (cl-ui:control-visible-p *mainwin*) t)
  (cl-ui:main))

(defun main ()
  (cl-ui:with-ui ()
    (%main)))
