module bazy.przychodnia {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;


    opens bazy.przychodnia to javafx.fxml;
    exports bazy.przychodnia;
}