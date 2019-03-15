const { flags } = require('@oclif/command');
const BaseCommand = require('../../lib/BaseCommand');

/**
 * List customers
 */
class ListCustomers extends BaseCommand {
  /**
   * Run command
   * @return {Promise<void>}
   */
  async run() {
    const { flags: { limit, offset } } = this.parse(ListCustomers);

    this.log(`Retrieve ${limit} customers from ${offset}`);
  }
}

ListCustomers.flags = {
  limit: flags.string({ char: 'l', description: 'records offset', default: 20 }),
  offset: flags.string({ char: 'o', description: 'records limit', default: 0 }),
};

ListCustomers.description = `List customers
...
List customers
`;

module.exports = ListCustomers;
