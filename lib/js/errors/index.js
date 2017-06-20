import ExtendableError from 'es6-error';

const ERROR_MESSAGES = {
    AbortError: 'The operation was aborted.', // Request cancelled
    InvalidStateError: 'The object is in an invalid state.',
    NotAllowedError: 'The request is not allowed by the user agent or the platform in the current context, possibly because the user denied permission.',
    NotSupportedError: 'The operation is not supported.',
    SecurityError: 'The operation is insecure.'
};

export class DOMException extends ExtendableError {
  constructor(errorType) {
    super(ERROR_MESSAGES[errorType]);
  }
}