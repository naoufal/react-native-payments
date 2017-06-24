const { DOMException } = require('..');

describe('errors', () => {
  describe('DOMException', () => {
    it('should init a `AbortError` `DOMException`', () => {
      expect(() => {
        throw new DOMException('AbortError');
      }).toThrow('The operation was aborted.');
    });

    it('should init a `InvalidStateError` `DOMException`', () => {
      expect(() => {
        throw new DOMException('InvalidStateError');
      }).toThrow('The object is in an invalid state.');
    });

    it('should init a `NotAllowedError` `DOMException`', () => {
      expect(() => {
        throw new DOMException('NotAllowedError');
      }).toThrow(
        'The request is not allowed by the user agent or the platform in the current context, possibly because the user denied permission.'
      );
    });

    it('should init a `NotSupportedError` `DOMException`', () => {
      expect(() => {
        throw new DOMException('NotSupportedError');
      }).toThrow('The operation is not supported.');
    });

    it('should init a `SecurityError` `DOMException`', () => {
      expect(() => {
        throw new DOMException('SecurityError');
      }).toThrow('The operation is insecure.');
    });
  });
});
