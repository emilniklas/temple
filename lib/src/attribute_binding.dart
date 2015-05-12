part of temple;

class AttributeBinding implements Binding {

  Element _element;
  String _attributeName;

  AttributeBinding(Element this._element, String this._attributeName);

  onChange(ChangeEvent event) {
    _update(event.newValue);
  }

  onCreate(CreateEvent event) {
    _update(event.value);
  }

  onDelete(DeleteEvent event) {
    _update('');
  }

  _update(String value) {
    _element.setAttribute(_attributeName, value);
  }
}