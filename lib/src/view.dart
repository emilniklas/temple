part of temple;

class View {

  DocumentFragment fragment;

  State _state;

  Map<String, List<Binding>> _bindings = {};

  static final List<String> templateAttributes = [
    'data-binding',
    'data-attribute-binding',
    'data-binding-scope',
  ];

  static final NodeValidatorBuilder validator = new NodeValidatorBuilder.common()
    ..allowElement('A', attributes: templateAttributes)
    ..allowElement('ABBR', attributes: templateAttributes)
    ..allowElement('ACRONYM', attributes: templateAttributes)
    ..allowElement('ADDRESS', attributes: templateAttributes)
    ..allowElement('AREA', attributes: templateAttributes)
    ..allowElement('ARTICLE', attributes: templateAttributes)
    ..allowElement('ASIDE', attributes: templateAttributes)
    ..allowElement('AUDIO', attributes: templateAttributes)
    ..allowElement('B', attributes: templateAttributes)
    ..allowElement('BDI', attributes: templateAttributes)
    ..allowElement('BDO', attributes: templateAttributes)
    ..allowElement('BIG', attributes: templateAttributes)
    ..allowElement('BLOCKQUOTE', attributes: templateAttributes)
    ..allowElement('BR', attributes: templateAttributes)
    ..allowElement('BUTTON', attributes: templateAttributes)
    ..allowElement('CANVAS', attributes: templateAttributes)
    ..allowElement('CAPTION', attributes: templateAttributes)
    ..allowElement('CENTER', attributes: templateAttributes)
    ..allowElement('CITE', attributes: templateAttributes)
    ..allowElement('CODE', attributes: templateAttributes)
    ..allowElement('COL', attributes: templateAttributes)
    ..allowElement('COLGROUP', attributes: templateAttributes)
    ..allowElement('COMMAND', attributes: templateAttributes)
    ..allowElement('DATA', attributes: templateAttributes)
    ..allowElement('DATALIST', attributes: templateAttributes)
    ..allowElement('DD', attributes: templateAttributes)
    ..allowElement('DEL', attributes: templateAttributes)
    ..allowElement('DETAILS', attributes: templateAttributes)
    ..allowElement('DFN', attributes: templateAttributes)
    ..allowElement('DIR', attributes: templateAttributes)
    ..allowElement('DIV', attributes: templateAttributes)
    ..allowElement('DL', attributes: templateAttributes)
    ..allowElement('DT', attributes: templateAttributes)
    ..allowElement('EM', attributes: templateAttributes)
    ..allowElement('FIELDSET', attributes: templateAttributes)
    ..allowElement('FIGCAPTION', attributes: templateAttributes)
    ..allowElement('FIGURE', attributes: templateAttributes)
    ..allowElement('FONT', attributes: templateAttributes)
    ..allowElement('FOOTER', attributes: templateAttributes)
    ..allowElement('FORM', attributes: templateAttributes)
    ..allowElement('H1', attributes: templateAttributes)
    ..allowElement('H2', attributes: templateAttributes)
    ..allowElement('H3', attributes: templateAttributes)
    ..allowElement('H4', attributes: templateAttributes)
    ..allowElement('H5', attributes: templateAttributes)
    ..allowElement('H6', attributes: templateAttributes)
    ..allowElement('HEADER', attributes: templateAttributes)
    ..allowElement('HGROUP', attributes: templateAttributes)
    ..allowElement('HR', attributes: templateAttributes)
    ..allowElement('I', attributes: templateAttributes)
    ..allowElement('IFRAME', attributes: templateAttributes)
    ..allowElement('IMG', attributes: templateAttributes)
    ..allowElement('INPUT', attributes: templateAttributes)
    ..allowElement('INS', attributes: templateAttributes)
    ..allowElement('KBD', attributes: templateAttributes)
    ..allowElement('LABEL', attributes: templateAttributes)
    ..allowElement('LEGEND', attributes: templateAttributes)
    ..allowElement('LI', attributes: templateAttributes)
    ..allowElement('MAP', attributes: templateAttributes)
    ..allowElement('MARK', attributes: templateAttributes)
    ..allowElement('MENU', attributes: templateAttributes)
    ..allowElement('METER', attributes: templateAttributes)
    ..allowElement('NAV', attributes: templateAttributes)
    ..allowElement('NOBR', attributes: templateAttributes)
    ..allowElement('OL', attributes: templateAttributes)
    ..allowElement('OPTGROUP', attributes: templateAttributes)
    ..allowElement('OPTION', attributes: templateAttributes)
    ..allowElement('OUTPUT', attributes: templateAttributes)
    ..allowElement('P', attributes: templateAttributes)
    ..allowElement('PRE', attributes: templateAttributes)
    ..allowElement('PROGRESS', attributes: templateAttributes)
    ..allowElement('Q', attributes: templateAttributes)
    ..allowElement('S', attributes: templateAttributes)
    ..allowElement('SAMP', attributes: templateAttributes)
    ..allowElement('SECTION', attributes: templateAttributes)
    ..allowElement('SELECT', attributes: templateAttributes)
    ..allowElement('SMALL', attributes: templateAttributes)
    ..allowElement('SOURCE', attributes: templateAttributes)
    ..allowElement('SPAN', attributes: templateAttributes)
    ..allowElement('STRIKE', attributes: templateAttributes)
    ..allowElement('STRONG', attributes: templateAttributes)
    ..allowElement('SUB', attributes: templateAttributes)
    ..allowElement('SUMMARY', attributes: templateAttributes)
    ..allowElement('SUP', attributes: templateAttributes)
    ..allowElement('TABLE', attributes: templateAttributes)
    ..allowElement('TBODY', attributes: templateAttributes)
    ..allowElement('TD', attributes: templateAttributes)
    ..allowElement('TEXTAREA', attributes: templateAttributes)
    ..allowElement('TFOOT', attributes: templateAttributes)
    ..allowElement('TH', attributes: templateAttributes)
    ..allowElement('THEAD', attributes: templateAttributes)
    ..allowElement('TIME', attributes: templateAttributes)
    ..allowElement('TR', attributes: templateAttributes)
    ..allowElement('TRACK', attributes: templateAttributes)
    ..allowElement('TT', attributes: templateAttributes)
    ..allowElement('U', attributes: templateAttributes)
    ..allowElement('UL', attributes: templateAttributes)
    ..allowElement('VAR', attributes: templateAttributes)
    ..allowElement('VIDEO', attributes: templateAttributes)
    ..allowElement('WBR', attributes: templateAttributes);

  View(String template, {Map<String, dynamic> initialData}) {

    fragment = _renderTemplate(template);

    _state = new State.fromMap({});

    _bind();

    _listen();

    _state.apply(initialData);
  }

  void _listen() {

    _state.change.listen(_onEvent);
    _state.create.listen(_onEvent);
    _state.delete.listen(_onEvent);
  }

  void _onEvent(event) {

    if (_bindings.containsKey(event.key)) {

      _bindings[event.key].forEach((Binding binding) {

        if (event is ChangeEvent) binding.onChange(event);
        else if (event is CreateEvent) binding.onCreate(event);
        else if (event is DeleteEvent) binding.onDelete(event);
      });
    }
  }

  DocumentFragment _renderTemplate(String template) {

    template = _applyAttributes(template);

    template = _applyVariables(template);

    return new DocumentFragment.html(template, validator: validator);
  }

  String _applyAttributes(String template) {

    RegExp singleAttributeMatcher
    = new RegExp(r'(<.*?)(\w+)\s*=\s*{{\s*(\w+)\s*}}');

    RegExp succeedingAttributeMatcher
    = new RegExp(r"(<.*?)(data-attribute-binding='(.*?)')(.*?)(\w+)\s*=\s*{{\s*(\w+)\s*}}");

    while (succeedingAttributeMatcher.hasMatch(template)
    || singleAttributeMatcher.hasMatch(template)) {

      if (succeedingAttributeMatcher.hasMatch(template)) {

        template = template.replaceFirstMapped(succeedingAttributeMatcher, (Match match) {

          String g1 = match.group(1);
          String g3 = match.group(3);
          String g4 = match.group(4);
          String g5 = match.group(5);
          String g6 = match.group(6);

          return "${g1}data-attribute-binding='${g3},${g5}:${g6}'${g4}${g5}=''";
        });
      } else {

        template = template.replaceFirstMapped(singleAttributeMatcher, (Match match) {

          String g1 = match.group(1);
          String g2 = match.group(2);
          String g3 = match.group(3);

          return "${g1}${g2}='' data-attribute-binding='${g2}:${g3}'";
        });
      }
    }

    return template;
  }

  String _applyVariables(String template) {

    RegExp matcher = new RegExp(r'{{\s*(.+?)\s*}}');

    return template.replaceAllMapped(matcher, (Match match) {

      String varName = match.group(1);

      return '<var data-binding="$varName"></var>';
    });
  }

  _bindVariables() {
    fragment.querySelectorAll('var[data-binding]').forEach((Element element) {

      String key = element.getAttribute('data-binding');

      DocumentFragment fragment = new DocumentFragment.html(' ');

      Binding binding = new TextBinding(fragment.firstChild);

      element.replaceWith(fragment);

      _addBinding(key, binding);
    });
  }

  _bindAttributes() {
    fragment.querySelectorAll('[data-attribute-binding]').forEach((Element element) {

      String bindingsExpression = element.getAttribute('data-attribute-binding');

      List<String> eachBindingExpression = bindingsExpression.split(',');

      eachBindingExpression.forEach((String bindingExpression) {

        List<String> bindingExpressionSplit = bindingExpression.split(':');

        String attributeName = bindingExpressionSplit[0];
        String bindingKey = bindingExpressionSplit[1];

        _addBinding(bindingKey, new AttributeBinding(element, attributeName));
      });

      element.setAttribute('data-attribute-binding', '');
    });
  }

  _addBinding(String key, Binding binding) {

    _ensureListenerKeyExists(key);

    _bindings[key].add(binding);
  }

  void _bind() {

    _bindVariables();

    _bindAttributes();
  }

  void _ensureListenerKeyExists(String key) {

    if (!_bindings.containsKey(key)) {

      _bindings[key] = [];
    }
  }

  void setState(Map<String, dynamic> state) => _state.apply(state);
}