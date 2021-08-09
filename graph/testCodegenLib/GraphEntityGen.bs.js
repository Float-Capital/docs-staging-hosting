// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");

require('graphql-import-node/register')
;

var result = require("../schema.graphql");

var entityDefinitions = result.definitions;

function getDefaultValues(typeString) {
  switch (typeString) {
    case "Address" :
        return "Address.fromString(\"0x0000000000000000000000000000000000000000\")";
    case "BigInt" :
        return "BigInt.fromI32(0)";
    case "Boolean" :
        return "false";
    case "Bytes" :
        return "Bytes.fromHexString(\"0x0\")";
    case "Int" :
        return "0";
    case "String" :
        return "\"\"";
    default:
      return "\"" + typeString + " - Unknown type\"";
  }
}

var enumsMap = {};

var interfacesMap = {};

var entitiesMap = {};

Belt_Array.forEach(entityDefinitions, (function (entity) {
        var name = entity.name.value;
        var entityKind = entity.kind;
        if (entityKind === "InterfaceTypeDefinition") {
          interfacesMap[name] = entity;
        } else if (entityKind === "ObjectTypeDefinition") {
          entitiesMap[name] = entity;
        } else {
          enumsMap[name] = entity;
        }
        
      }));

function getFieldType(field) {
  var uncaught = field.kind;
  if (uncaught === "NonNullType") {
    return getFieldType(field.type) + " | null";
  } else if (uncaught === "NamedType") {
    return field.type.value;
  } else if (uncaught === "ListType") {
    return "array<" + getFieldType(field.type) + ">";
  } else {
    console.log(uncaught);
    return "unknown";
  }
}

function getDefaultValueForType(typeName) {
  return Belt_Option.mapWithDefault(Js_dict.get(entitiesMap, typeName), Belt_Option.mapWithDefault(Js_dict.get(enumsMap, typeName), getDefaultValues(typeName), (function ($$enum) {
                    return "\"" + $$enum.values[0].name.value + "\"";
                  })), (function (_entityType) {
                return "\"UNITITIALIZED - " + typeName + "\"";
              }));
}

function getFieldDefaultTypeNonNull(_field) {
  while(true) {
    var field = _field;
    var uncaught = field.kind;
    if (uncaught !== "NonNullType") {
      if (uncaught === "NamedType") {
        return getDefaultValueForType(field.name.value);
      } else if (uncaught === "ListType") {
        return "[]";
      } else {
        console.log(uncaught);
        return "unknown";
      }
    }
    _field = field.type;
    continue ;
  };
}

function getFieldDefaultTypeWithNull(field) {
  var uncaught = field.kind;
  if (uncaught === "NonNullType") {
    return getFieldDefaultTypeNonNull(field.type);
  } else if (uncaught === "ListType" || uncaught === "NamedType") {
    return "null";
  } else {
    console.log(uncaught);
    return "unknown";
  }
}

var functions = Belt_Array.joinWith(Belt_Array.map(Object.keys(entitiesMap), (function (entityName) {
            var entity = entitiesMap[entityName];
            var name = entity.name.value;
            var fields = entity.fields;
            var fieldDefaultSetters = Belt_Array.joinWith(Belt_Array.map(fields, (function (field) {
                        var fieldName = field.name.value;
                        if (fieldName === "id") {
                          return "";
                        } else {
                          return "    loaded" + name + "." + fieldName + " = " + getFieldDefaultTypeWithNull(field.type);
                        }
                      })), "\n", (function (a) {
                    return a;
                  }));
            return "\nexport function getOrInitialize" + name + "(entityId: string): GetOrCreateReturn<" + name + "> {\n  let loaded" + name + " = " + name + ".load(entityId);\n\n  let returnObject = new GetOrCreateReturn(loaded" + name + " as " + name + ", false);\n\n  if (loaded" + name + " == null) {" + fieldDefaultSetters + "\n    loaded" + name + ".save();\n\n    returnObject.wasCreated = true;\n  }\n\n  return returnObject;\n}\nexport function get" + name + "(entityId: string): " + name + " {\n  let loaded" + name + " = " + name + ".load(entityId);\n\n  if (loaded" + name + " == null) {\n    log.critical(\"Unable to find entity of type " + name + " with id {}. If this entity hasn't been initialized use the 'getOrInitialize" + name + "' and handle the case that it needs to be initialized.\", [entityId])\n  }\n\n  return loaded" + name + " as " + name + ";\n}";
          })), "\n", (function (a) {
        return a;
      }));

var entityImports = Belt_Array.joinWith(Belt_Array.map(Belt_Array.keep(entityDefinitions, (function (entity) {
                if (entity.kind !== "EnumTypeDefinition") {
                  return entity.kind !== "InterfaceTypeDefinition";
                } else {
                  return false;
                }
              })), (function (entity) {
            return "  " + entity.name.value;
          })), ",\n", (function (a) {
        return a;
      }));

var outputCode = "import {\n" + entityImports + "\n} from \"../../generated/schema\";\nimport {\n  Address,\n  BigInt,\n  Bytes,\n  ethereum,\n  store,\n  Value,\n  log,\n} from \"@graphprotocol/graph-ts\";\n\nexport class GetOrCreateReturn<EntityType> {\n  entity: EntityType;\n  wasCreated: boolean;\n\n  constructor(entity: EntityType, wasCreated: boolean) {\n    this.entity = entity;\n    this.wasCreated = wasCreated;\n  }\n}\n" + functions + "\n";

Fs.writeFileSync("./src/generated/EntityCreators.ts", outputCode, "utf8");

exports.result = result;
exports.entityDefinitions = entityDefinitions;
exports.getDefaultValues = getDefaultValues;
exports.enumsMap = enumsMap;
exports.interfacesMap = interfacesMap;
exports.entitiesMap = entitiesMap;
exports.getFieldType = getFieldType;
exports.getDefaultValueForType = getDefaultValueForType;
exports.getFieldDefaultTypeNonNull = getFieldDefaultTypeNonNull;
exports.getFieldDefaultTypeWithNull = getFieldDefaultTypeWithNull;
exports.functions = functions;
exports.entityImports = entityImports;
exports.outputCode = outputCode;
/*  Not a pure module */
