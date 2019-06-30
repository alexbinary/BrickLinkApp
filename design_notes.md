#  Design notes

## Testing the BrickLink authentication code

The BrickLink authentication code exposes a single public function that adds authentication datga to a request using a provided set of credentials.

The public function uses several smaller private functions. These functions are implementation details and must not be public.

Testing private functions is impossible and that is ok because testing is about the specification, not the implementation.

That being said, the only way to verify that the authentication code generates correct authentication data is to independently compute the authentication data and compare it with the data produced by the code under tests.

Since the authentication spec involves random data generated for each signature, pre-computing the result for a fixed set of inputs is impossible. We have to have the test code compute it dynamically.

Having similar code for the tests and for the actual code might seem useless, but in fact it provides redundency that in turns provides the insurance against changes that unit tests are all about.
