const BaseCommand = require('../../lib/BaseCommand');

/**
 * Create customer
 */
class CreateCustomer extends BaseCommand {
  /**
   * Run command
   * @return {Promise<void>}
   */
  async run() {
    //
  }
}

CreateCustomer.description = `Create customer
...
Create customer
`;

module.exports = CreateCustomer;
