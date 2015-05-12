part of temple;

class TextBinding implements Binding {

  Text _node;

  TextBinding(Text this._node);

  onChange(ChangeEvent event) {

    _node.replaceData(0, _node.length, event.newValue);
  }

  onDelete(DeleteEvent event) {

    _node.replaceData(0, _node.length, '');
  }

  onCreate(CreateEvent event) {

    _node.replaceData(0, _node.length, event.value);
  }
}