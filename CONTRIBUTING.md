1. Fork and clone the repo:
`git clone git@github.com:your-username/redis_hash_store.git`
2. Install `Redis`:
 * `Homebrew` for MacOS users:
  `brew install redis`
 * `From Source`:
  Download and install Redis from the [download page](http://redis.io/download) and follow the instructions.
3. Run setup commands:
```bash
bundle install
appraisal install
```
4. Make sure all the tests passed:
```bash
appraisal rake
```
5. Follow next steps: 
  * Write your feature/fix.
  * Add tests for your feature/fix.
  * Make the tests pass: `point 4.`

6. Push to your fork and [submit a pull request](https://github.com/mrsool/redis_hash_store/compare/).
