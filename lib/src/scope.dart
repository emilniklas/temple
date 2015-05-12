part of temple;

class Scope implements Binding {

  String template;

  State _state = new State.fromMap({});

  onChange(ChangeEvent event) {
    _update
  }

  onCreate(CreateEvent event) {
    // TODO: implement onCreate
  }

  onDelete(DeleteEvent event) {
    // TODO: implement onDelete
  }
}