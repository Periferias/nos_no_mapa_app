import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15
import QtQuick.Window 2.15

ListView {
  id: categoryPicker

  property bool hasForm: typeof(form) !== "undefined"
  property int categoryWidth: Math.max(100, width / 5 - 16)
  property string attribute: "category"
  property string currentCategory: expression.evaluate("\"category\"") !== "" && hasForm ? form.model.attribute(attribute) : ""
  
  // @project_folder gives e.g. "/data/.../project/" on Android, "C:\Users\...\project\" on Windows.
  // On Android "file://" + "/data/..." = "file:///data/..." (correct).
  // On Windows we need to replace backslashes and prepend "/" so
  // "file://" + "/C:/Users/..." = "file:///C:/Users/..." (correct).
  property string projectPath: {
    var raw = expression.evaluate("replace(@project_folder, char(92), '/') || '/'")
    if (raw.charAt(0) !== "/") raw = "/" + raw
    return raw
  }
    
  width: parent && parent.width > 0 ? parent.width : 400
  height: Math.max(100, width / 5 - 16)
  clip: true
  
  model: ListModel {
    ListElement {
      categoryIcon: "assets/culture.svg"
      categoryColor: "#fc372c"
      categoryValue: "culture"
    }
    ListElement {
      categoryIcon: "assets/environment.svg"
      categoryColor: "#8d5dff"
      categoryValue: "environment"
    }
    ListElement {
      categoryIcon: "assets/housing.svg"
      categoryColor: "#fbd13d"
      categoryValue: "housing"
    }
    ListElement {
      categoryIcon: "assets/infrastructure.svg"
      categoryColor: "#00ad36"
      categoryValue: "infrastructure"
    }
    ListElement {
      categoryIcon: "assets/work.svg"
      categoryColor: "#3f8bca"
      categoryValue: "work"
    }
  }
  
  snapMode: ListView.SnapToItem
  orientation: ListView.Horizontal
  spacing: 4
  
  delegate: RoundButton {
    id: button
  
    property color buttonColor: categoryColor
  
    width: categoryPicker.height
    height: categoryPicker.height
    topInset: 0
    bottomInset: 0
    leftInset: 0
    rightInset: 0
    padding: 10
  
    icon.source: "file://" + projectPath + categoryIcon
    icon.color: categoryPicker.currentCategory == categoryValue ? "#ffffff" : Material.foreground
    icon.width: parent.width
    icon.height: parent.width
    
    background: Rectangle {
      id: backgroundRectangle
      implicitWidth: 100
      implicitHeight: 25
      radius: 0
      clip: true
      color: categoryPicker.currentCategory == categoryValue ? categoryColor : "transparent"
      border.color: hasForm && form.state !== "ReadOnly" ? categoryColor : "transparent"
      border.width: 4
    
      Ripple {
        id: ripple
        clip: true
        width: parent.width
        height: parent.height
        clipRadius: 4
        pressed: button.down
        anchor: parent
        active: button.down
        color: "#10555555"
      }
    }
    
    onClicked: {
      if (hasForm && form.state !== "ReadOnly") {
        form.model.changeAttribute(categoryPicker.attribute, categoryValue);
        categoryPicker.currentCategory = categoryValue;
      }
    }
  }

  Component.onCompleted: {
    for(let i = 0; i < categoryPicker.model.count; i++) {
      const item = categoryPicker.model.get(i);
      if (item.categoryValue == categoryPicker.currentCategory) {
      categoryPicker.positionViewAtIndex(i,ListView.Center);
      break;
      }
    }
  }
}
