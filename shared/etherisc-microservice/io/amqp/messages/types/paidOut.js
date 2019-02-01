const schemaVersions = {};

schemaVersions['1.0'] = {
  id: 'paidOut',
  type: 'object',
  properties: {
    policyId: { type: 'string' },
  },
  required: ['policyId'],
};

module.exports = schemaVersions;