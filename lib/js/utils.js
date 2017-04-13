export function setReadOnlyAttributesOnObject(sourceObject, readOnlyAttributes) {
    const properties = readOnlyAttributes.reduce((accumulator, attribute) => {
      if (!sourceObject[attribute]) {
        return accumulator;
      }

      return Object.assign({}, accumulator, {
        [attribute]: {
          value: sourceObject[attribute],
          writable: false,
          configurable: false,
          enumerable: true
        }
      });
    }, {});

    return (targetObject) => {
      Object.defineProperties(targetObject, properties);
    }
}