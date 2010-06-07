from distutils.core import setup, Extension

setup	(name = 'krbV',
	version = '1.0.90',
	description = 'Kerberos V Bindings for Python',
        long_description = """
python-krbV allows python programs to use Kerberos 5 authentication/security
""",
	author = 'Test',
	author_email = 'mikeb@redhat.com',
	classifiers = [
		'Development Status :: 4 - Beta',
		'License :: OSI Approved :: GNU General Public License (LGPL)',
		'Operating System :: POSIX :: Linux',
		'Programming Language :: C',
		'Topic :: System :: Systems Administration :: Authentication/Directory'
		],
	ext_modules = 	[Extension	('krbV', 
					[ 'krb5util.c', 'krb5module.c', 'krb5err.c' ],
					libraries = ['krb5', 'com_err']
					)
			]
	)
