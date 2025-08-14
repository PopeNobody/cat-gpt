# cat-gpt Perl Example

This repo contains a Perl example using [OpenAI::API](https://metacpan.org/pod/OpenAI::API), with local CPAN install for portability.

## Setup

1. **Install dependencies locally:**

   ```sh
   cpanm --installdeps . --local-lib local
   ```

   If you don’t have `cpanm`, install it first:

   ```sh
   cpan App::cpanminus
   ```

2. **Set your OpenAI API key:**

   ```sh
   export OPENAI_API_KEY=your-api-key
   ```

3. **Run the example:**

   ```sh
   perl sample.pl
   ```

## Notes

- All dependencies are installed into `local/` so you don’t need system-wide access.
- The example is adapted from the `OpenAI::API` man page and is ready to run.
