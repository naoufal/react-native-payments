const {
  isValidDecimalMonetaryValue,
  isValidStringAmount,
  toNumber
} = require('..');

describe('helpers', () => {
  describe('isValidDecimalMonetaryValue', () => {
    it('`Array` should not be a valid string amount', () => {
      expect(isValidDecimalMonetaryValue([])).toBe(false);
    });

    it('`Object` should not be a valid string amount', () => {
      expect(isValidDecimalMonetaryValue({})).toBe(false);
    });

    it('`Function` should not be a valid string amount', () => {
      expect(isValidDecimalMonetaryValue(() => {})).toBe(false);
    });

    it('`undefined` should not be a valid string amount', () => {
      expect(isValidDecimalMonetaryValue(undefined)).toBe(false);
    });

    it('`null` should not be a valid string amount', () => {
      expect(isValidDecimalMonetaryValue(null)).toBe(false);
    });
  });

  describe('isValidStringAmount', () => {
    it('`9.999` should not be a valid string amount', () => {
      expect(isValidStringAmount('9.999')).toBe(true);
    });

    it('`9.99` should be a valid string amount', () => {
      expect(isValidStringAmount('9.99')).toBe(true);
    });

    it('`9.9` should be a valid string amount', () => {
      expect(isValidStringAmount('9.9')).toBe(true);
    });

    it('`9` should be a valid string amount', () => {
      expect(isValidStringAmount('9')).toBe(true);
    });

    it('`9.` should not be a valid string amount', () => {
      expect(isValidStringAmount('9.')).toBe(false);
    });
  });

  describe('toNumber', () => {
    it('"9.999" should convert to 9.999', () => {
      expect(toNumber('9.999')).toBe(9.999);
    });

    it('"9.99" should convert to 9.99', () => {
      expect(toNumber('9.99')).toBe(9.99);
    });

    it('"9.9" should convert to 9.9', () => {
      expect(toNumber('9.9')).toBe(9.9);
    });

    it('"9" should convert to 9', () => {
      expect(toNumber('9')).toBe(9);
    });
  });
});
