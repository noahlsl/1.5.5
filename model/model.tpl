package {{.pkg}}
{{if .withCache}}
import (
    "fmt"
    "context"

    "github.com/doug-martin/goqu/v9"
    "github.com/noahlsl/goqu_zero/option"
    "github.com/zeromicro/go-zero/core/logx"
    "github.com/zeromicro/go-zero/core/stores/sqlx"
	"github.com/zeromicro/go-zero/core/stores/cache"
)
{{else}}

import (
    "fmt"
    "context"

    "github.com/doug-martin/goqu/v9"
    "github.com/noahlsl/goqu_zero/option"
    "github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

{{end}}
var _ {{.upperStartCamelObject}}Model = (*custom{{.upperStartCamelObject}}Model)(nil)

type (
	// {{.upperStartCamelObject}}Model is an interface to be customized, add more methods here,
	// and implement the added methods in custom{{.upperStartCamelObject}}Model.
	{{.upperStartCamelObject}}Model interface {
	    {{.lowerStartCamelObject}}Model
        InstallErrDoNothing(ctx context.Context, in *{{.upperStartCamelObject}}) error
        InstallErrDoUpdate(ctx context.Context, in *{{.upperStartCamelObject}},uniKey string, record goqu.Record, opts ...option.Option) error
        FindSum(ctx context.Context, field string, opts ...option.Option) (float64, error)
        FindCount(ctx context.Context, opts ...option.Option) (int64, error)
        First(ctx context.Context, opts ...option.Option) (*{{.upperStartCamelObject}}, error)
        FindAll(ctx context.Context, opts ...option.Option) ([]*{{.upperStartCamelObject}}, error)
        FindList(ctx context.Context, page, size uint, opts ...option.Option) ([]*{{.upperStartCamelObject}}, error)
        FindListWithTotal(ctx context.Context, page, size uint, opts ...option.Option) ([]*{{.upperStartCamelObject}}, int64, error)
        UpdateFields(ctx context.Context,record goqu.Record, opts ...option.Option) error
        Trans(ctx context.Context, fn func(context context.Context, session sqlx.Session) error) error
        DeleteTx(ctx context.Context, session sqlx.Session, id interface{}, opts ...option.Option) error
        UpdateTx(ctx context.Context, session sqlx.Session, opts ...option.Option) error
        InstallTx(ctx context.Context, session sqlx.Session, in *{{.upperStartCamelObject}}) error
	}

	custom{{.upperStartCamelObject}}Model struct {
		*default{{.upperStartCamelObject}}Model
	}
)

// New{{.upperStartCamelObject}}Model returns a model for the database table.
func New{{.upperStartCamelObject}}Model(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf, opts ...cache.Option{{end}}) {{.upperStartCamelObject}}Model {
	return &custom{{.upperStartCamelObject}}Model{
		default{{.upperStartCamelObject}}Model: new{{.upperStartCamelObject}}Model(conn{{if .withCache}}, c, opts...{{end}}),
	}
}

func (c custom{{.upperStartCamelObject}}Model) InstallErrDoNothing(ctx context.Context, in *{{.upperStartCamelObject}}) error {

	query, _, err := option.GenInstall(c.table, in,option.WithErrDoNothing())
    if err != nil {
        return err
    }

    logx.Debug(query)
    {{if .withCache}}
    _,err = c.ExecNoCacheCtx(ctx, query)
    {{else}}
    _,err = c.conn.ExecCtx(ctx, query)
    {{end}}
    if err != nil {
        return err
    }

	return nil
}

func (c custom{{.upperStartCamelObject}}Model) InstallErrDoUpdate(ctx context.Context, in *{{.upperStartCamelObject}}, uniKey string, record goqu.Record, opts ...option.Option) error {

    opts = append(opts, option.WithErrDoUpdate(), option.WithUniKey(uniKey), option.WithSetRecord(record))
    query, _, err := option.GenInstall(c.table, in, opts...)
    if err != nil {
        return err
    }

    logx.Debug(query)
    {{if .withCache}}
    _,err = c.ExecNoCacheCtx(ctx, query)
    {{else}}
    _,err = c.conn.ExecCtx(ctx, query)
    {{end}}
    if err != nil {
        return err
    }

	return nil
}

func (c custom{{.upperStartCamelObject}}Model) FindSum(ctx context.Context, field string, opts ...option.Option) (sum float64,err error) {
	var resp float64
	opts = append(opts, option.WithFields(fmt.Sprintf("SUM(%s)", field)))
	query, _, err := option.GenSelect(c.table, opts...)
	if err != nil {
		return 0, err
	}

	logx.Debug(query)
    {{if .withCache}}
    err = c.QueryRowNoCacheCtx(ctx, &resp, query)
    {{else}}
    err = c.conn.QueryRowCtx(ctx, &resp, query)
    {{end}}
	if err != nil {
		return 0, err
	}

	return resp, nil
}

func (c custom{{.upperStartCamelObject}}Model) FindCount(ctx context.Context, opts ...option.Option) (count int64,err error) {
	var resp int64
	opts = append(opts, option.WithFields("COUNT(1)"))
	query, _, err := option.GenSelect(c.table, opts...)
	if err != nil {
		return 0, err
	}

	logx.Debug(query)
    {{if .withCache}}
    err = c.QueryRowNoCacheCtx(ctx, &resp, query)
    {{else}}
    err = c.conn.QueryRowCtx(ctx, &resp, query)
    {{end}}
	if err != nil {
		return 0, err
	}

	return resp, nil
}

func (c custom{{.upperStartCamelObject}}Model) First(ctx context.Context, opts ...option.Option) (*{{.upperStartCamelObject}}, error) {
	var resp *{{.upperStartCamelObject}}
	query, _, err := option.GenSelect(c.table, opts...)
	if err != nil {
		return nil, err
	}

	logx.Debug(query)
    {{if .withCache}}
    err = c.QueryRowNoCacheCtx(ctx, &resp, query)
    {{else}}
    err = c.conn.QueryRowCtx(ctx, &resp, query)
    {{end}}
	if err != nil {
		return nil, err
	}

	return resp, nil
}

func (c custom{{.upperStartCamelObject}}Model) FindAll(ctx context.Context, opts ...option.Option) (result []*{{.upperStartCamelObject}}, err error) {
	var resp []*{{.upperStartCamelObject}}
	query, _, err := option.GenSelect(c.table, opts...)
	if err != nil {
		return nil, err
	}

	logx.Debug(query)
    {{if .withCache}}
    err = c.QueryRowsNoCacheCtx(ctx, &resp, query)
    {{else}}
    err = c.conn.QueryRowsCtx(ctx, &resp, query)
    {{end}}
	if err != nil {
		return nil, err
	}

	return resp, nil
}

func (c custom{{.upperStartCamelObject}}Model) FindList(ctx context.Context, page, size uint, opts ...option.Option) (result []*{{.upperStartCamelObject}}, err error) {
	var resp []*{{.upperStartCamelObject}}
	opts = append(opts, option.WithPageSize(page, size))
	query, _, err := option.GenSelect(c.table, opts...)
	if err != nil {
		return nil, err
	}

	logx.Debug(query)
    {{if .withCache}}
    err = c.QueryRowsNoCacheCtx(ctx, &resp, query)
    {{else}}
    err = c.conn.QueryRowsCtx(ctx, &resp, query)
    {{end}}
	if err != nil {
		return nil, err
	}

	return resp, nil
}

func (c custom{{.upperStartCamelObject}}Model) FindListWithTotal(ctx context.Context, page, size uint, opts ...option.Option) (result []*{{.upperStartCamelObject}}, total int64,err error) {

	count, err := c.FindCount(ctx, opts...)
	if err != nil {
		return nil, 0, err
	}

	if count == 0 {
		return nil, 0, err
	}

	resp, err := c.FindList(ctx, page, size, opts...)
	if err != nil {
		return nil, 0, err
	}

	return resp, count, nil
}

func (c custom{{.upperStartCamelObject}}Model) UpdateFields(ctx context.Context,record goqu.Record, opts ...option.Option) error {

    opts = append(opts, option.WithSetRecord(record))
    query, _, err := option.GenUpdate(c.table, opts...)
    if err != nil {
        return err
    }

    logx.Debug(query)
    {{if .withCache}}
    _, err = c.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
            return conn.ExecCtx(ctx, query)
        },)
    {{else}}
    _,err = c.conn.ExecCtx(ctx, query)
    {{end}}
    if err != nil {
        return err
    }

	return nil
}
func (c custom{{.upperStartCamelObject}}Model) Trans(ctx context.Context, fn func(context context.Context, session sqlx.Session) error) error {
	{{if .withCache}}
	return c.TransactCtx(ctx, func(ctx context.Context, session sqlx.Session) error {
		return fn(ctx, session)
	})
	{{else}}
    return c.conn.TransactCtx(ctx, func(ctx context.Context, session sqlx.Session) error {
        return fn(ctx, session)
    })
	{{end}}
}

func (c custom{{.upperStartCamelObject}}Model) DeleteTx(ctx context.Context, session sqlx.Session, id interface{}, opts ...option.Option) error {

	query, _, err := option.GenDelete(c.table, opts...)
	if err != nil {
		return err
	}

    {{if .withCache}}
    var keys []string
    keys = append(keys, fmt.Sprintf("%v:%v", cache{{.upperStartCamelObject}}IdPrefix, id))
    err = c.CachedConn.DelCache(keys...)
    if err != nil {
        return err
    }
    {{end}}

	_, err = session.ExecCtx(ctx, query)
	return err
}

func (c custom{{.upperStartCamelObject}}Model) UpdateTx(ctx context.Context, session sqlx.Session, opts ...option.Option) error {

	query, _, err := option.GenUpdate(c.table, opts...)
	if err != nil {
		return err
	}

	{{if .withCache}}
    execCtx, err := session.ExecCtx(ctx, query)
    if err != nil {
        return err
    }
    id, err := execCtx.RowsAffected()
    if err != nil {
        return err
    }
	var keys []string
	keys = append(keys, fmt.Sprintf("%v:%v", cache{{.upperStartCamelObject}}IdPrefix, id))
	err = c.CachedConn.DelCache(keys...)
	if err != nil {
		return err
	}
	{{else}}
    _, err = session.ExecCtx(ctx, query)
    if err != nil {
        return err
    }
    {{end}}

	return err
}
func (c custom{{.upperStartCamelObject}}Model) InstallTx(ctx context.Context, session sqlx.Session, in *{{.upperStartCamelObject}}) error {

	query, _, err := option.GenInstall(c.table, in)
	if err != nil {
		return err
	}

    {{if .withCache}}
    execCtx, err := session.ExecCtx(ctx, query)
    if err != nil {
        return err
    }
    id, err := execCtx.LastInsertId()
    if err != nil {
        return err
    }

	key := fmt.Sprintf("%v:%v", cache{{.upperStartCamelObject}}IdPrefix, id)
	err = c.CachedConn.SetCacheCtx(ctx, key, in)
	if err != nil {
		return err
	}
	{{else}}
    _, err = session.ExecCtx(ctx, query)
    if err != nil {
        return err
    }
    {{end}}

	return nil
}