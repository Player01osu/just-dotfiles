#if 0
set -e
cc -o udf udf.c -pedantic -DPWD="s($(pwd))" -DCONFIG="d(${XDG_CONFIG_HOME})" -DHOME="d(${HOME})"
./udf
rm udf
exit
#endif

#define s(x) #x
#define c(s) PWD "/" s
#define d(x) s(x) "/"
#define ON   (void *) 69
#define OFF  (void *) 0

/******************/
/* Configurations */
/******************/

/* Sudo program */
const char *sudo = "/usr/bin/doas";

/* Set the path and link location of files */
const char *links[][4] = {
        /* Config                        Link location                Sudo     Enabled  */
	{ c(".config/fcitx"),           CONFIG "/fcitx",              0,       ON },
	{ c(".config/lf"),              CONFIG "/lf",                 0,       0  },
	{ c(".config/mpd"),             CONFIG "/mpd",                0,       0  },
	{ c(".config/mpv"),             CONFIG "/mpv",                0,       0  },
	{ c(".config/ncmpcpp"),         CONFIG "/ncmpcpp",            0,       0  },
	{ c(".config/nvim"),            CONFIG "/nvim",               0,       0  },
	{ c(".config/pipewire"),        CONFIG "/pipewire",           0,       0  },
	{ c(".config/sx"),              CONFIG "/sx",                 0,       0  },
	{ c(".config/sxhkd")            CONFIG "/sxhkd",              0,       0  },
	{ c(".config/zsh"),             CONFIG "/zsh",                0,       0  },
	{ c(".config/alacritty.toml"),  CONFIG "/alacritty.toml",     0,       0  },
	{ c(".config/picom.conf"),      CONFIG "/picom.conf",         0,       0  },
	{ c(".zshenv"),                 "/etc/zsh/zshenv",            ON,      0  },
};

/**********/
/* Script */
/**********/
#undef d
#undef c
#undef s

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

#define ARR_LEN(arr) (sizeof(arr) / sizeof(*arr))

const char *program_name;

static int exists(const char *path)
{
	return access(path, F_OK) == 0;
}

static void concat(char *buf, ...)
{
	va_list ap;
	char    *s;

	buf[0] = '\0';
	va_start(ap, buf);
	s = va_arg(ap, char *);
	while (s) {
		strcat(buf, s);
		s = va_arg(ap, char *);
	}
	va_end(ap);
}

static int link_file(const char *from, const char *to)
{
	int  ret;

	ret = symlink(from, to);
	if (ret && errno == EEXIST) {
		fprintf(stdout, "  \"%s\" to \"%s\": File already exists; Continuing...\n", from, to);
	} else if (ret) {
		fprintf(stderr, "%s: Could not symlink file \"%s\" to \"%s\": %s\n", program_name, from, to, strerror(errno));
		return -1;
	} else {
		fprintf(stdout, "  Linking \"%s\" to \"%s\"...\n", from, to);
	}
	return 0;
}

static void pop_path(char *buf, const char *path)
{
	const char *p;
	char       *p_buf;
	p     = path;
	p_buf = buf;
	/* Seek to end */
	while (*p) {
		++p;
	}
	--p;
	/* Remove trailing '/' */
	while (p > path && *p == '/') --p;
	/* Pop until '/' */
	while (p > path && *p != '/') --p;
	/* Remove trailing '/' */
	while (p > path && *p == '/') --p;
	/* Consume path until p, pushing onto buf */
	while (path <= p && *path) {
		*p_buf = *path;
		++p_buf;
		++path;
	}
	*p_buf = '\0';
}

int main(int argc, char **argv)
{
	size_t i;
	int    root_once;
	uid_t  uid;
	uid_t  gid;

	program_name = argv[0];
	root_once    = 0;
	uid          = getuid();
	gid          = getgid();

	if (argc == 3) {
		uid = atoi(argv[1]);
		gid = atoi(argv[2]);
	}

	/* If program already has root, assume this check has already been performed */
	if (getuid()) {
		/* Check files exist and check whether needs sudo */
		for (i = 0; i < ARR_LEN(links); ++i) {
			const char *from;
			const char *to;
			const char *require_root;
			const char *enabled;
			char to_buf[512];

			from         = links[i][0];
			to           = links[i][1];
			require_root = links[i][2];
			enabled      = links[i][3];

			if (!enabled) continue;

			if (!exists(from)) {
				fprintf(stderr, "%s: Could not stat src file: \"%s\"\n", program_name, from);
				return 1;
			}

			pop_path(to_buf, to);
			if (!exists(to_buf)) {
				fprintf(stderr, "%s: Could not stat dest file: \"%s\"\n", program_name, to);
				return 1;
			}
			if (require_root) {
				root_once = 1;
			}
		}

		if (root_once) {
			char uid_buf[32];
			char gid_buf[32];

			sprintf(uid_buf, "%d", uid);
			sprintf(gid_buf, "%d", gid);
			execl(sudo, program_name, program_name, uid_buf, gid_buf, NULL);
			fprintf(stderr, "%s: Could not exec sudo: \"%s\"\n", program_name, sudo);
			fprintf(stderr, "Check if you have the program installed or change `sudo` to appropriate path\n");
			return 1;
		}
	}

	/* Do all sudo links */
	if (!getuid()) {
		for (i = 0; i < ARR_LEN(links); ++i) {
			const char *from;
			const char *to;
			const char *require_root;
			const char *enabled;

			from         = links[i][0];
			to           = links[i][1];
			require_root = links[i][2];
			enabled      = links[i][4];

			if (!enabled) continue;

			if (require_root) {
				if (link_file(from, to) < 0) return 1;
			}
		}
	}

	/* Drop privileges */
	if (!getuid()) {
		if (setgid(gid)) {
			fprintf(stderr, "%s: Could not drop group privileges: %s\n", program_name, strerror(errno));
			return 1;
		}
		if (setuid(uid)) {
			fprintf(stderr, "%s: Could not drop user privileges: %s\n", program_name, strerror(errno));
			return 1;
		}
	}

	/* Do all non-sudo links */
	for (i = 0; i < ARR_LEN(links); ++i) {
		const char *from;
		const char *to;
		const char *require_root;
		const char *enabled;

		from         = links[i][0];
		to           = links[i][1];
		require_root = links[i][2];
		enabled      = links[i][3];

		if (!enabled) continue;

		if (!require_root) {
			if (link_file(from, to) < 0) return 1;
		}
	}
	return 0;
}
