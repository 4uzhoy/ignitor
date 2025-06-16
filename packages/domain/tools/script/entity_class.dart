class EntityClass {
  const EntityClass({required this.name, required this.fields, required this.methods});
  final String name;
  final List<EntityField> fields;
  final List<String> methods;
}

class EntityField {
  const EntityField({required this.name, required this.type, this.isNullable = false});
  final String name;
  final String type;
  final bool isNullable;
}
